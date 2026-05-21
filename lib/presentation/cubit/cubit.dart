import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdetection/app/file_picker.dart';
import '../../app/plan_live_detection.dart';
import '../../app/plant_recognition_service.dart';
import '../../domain/models/models.dart';
import '../resources/helper.dart';
import 'states.dart';
import 'dart:async';

class AppCubit extends Cubit<AppStates> {
  AppCubit(this._filePicker, this._recognitionService)
    : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  final AppFilePicker _filePicker;
  final IPlantRecognitionService _recognitionService;

  // ─── Live detection ────────────────────────────────────────────────────────
  CameraController? _cameraController;
  PlantLiveDetectionService? _liveService;
  StreamSubscription<PlantifyPrediction?>? _liveSub;

  CameraController? get cameraController => _cameraController;

  void onCloseApp() {
    _disposeLive();
    _recognitionService.dispose();
  }

  PlantDetails getPlantByIndex(int index) =>
      _recognitionService.plants.firstWhere((e) => e.index == index);

  // ─── Home ──────────────────────────────────────────────────────────────────
  GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey();

  void openHomeDrawer() => homeScaffoldKey.currentState?.openDrawer();

  // ─── Gallery / Camera (unchanged) ─────────────────────────────────────────
  Future<void> pickGalleryImage(BuildContext context) async {
    _filePicker.pickSingleImage().then((picked) async {
      if (picked != null) {
        await _recognitionService.recognizeImage(picked).then((prediction) {
          if (prediction != null) {
            AppHelpers.showPickedImageDetails(
              context,
              file: picked,
              prediction: prediction,
              details: getPlantByIndex(prediction.index),
            );
          }
        });
      }
    });
  }

  Future<void> takePhotoFromCamera(BuildContext context) async {
    _filePicker.catchCameraImage().then((picked) async {
      if (picked != null) {
        final file = File(picked.path);
        await _recognitionService.recognizeImage(file).then((prediction) {
          if (prediction != null) {
            AppHelpers.showPickedImageDetails(
              context,
              file: file,
              prediction: prediction,
              details: getPlantByIndex(prediction.index),
            );
          }
        });
      }
    });
  }

  // ─── Live Scan ─────────────────────────────────────────────────────────────

  Future<void> startLiveScan(List<CameraDescription> cameras) async {
    if (cameras.length < 2) {
      emit(LiveScanErrorState('No cameras available'));
      return;
    }

    emit(LiveScanLoadingState());

    try {
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium, // Lower = less CPU, still fine for 224×224
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      _liveService = await _recognitionService.startLiveDetection();

      _liveSub = _liveService!.results.listen(_onLiveResult);

      await _cameraController!.startImageStream(_liveService!.processFrame);

      emit(LiveScanActiveState());
    } catch (e) {
      _disposeLive();
      emit(LiveScanErrorState(e.toString()));
    }
  }

  void _onLiveResult(PlantifyPrediction? result) {
    if (result == null) return;
    if (state is LiveScanDetectedState) return; // Already paused — ignore

    if (!result.isPlant) return;
    // Stop feeding frames; camera preview stays alive
    _cameraController?.stopImageStream();

    emit(
      LiveScanDetectedState(
        plantImage: null,
        result: result,
        details: getPlantByIndex(result.index),
      ),
    );
  }

  Future<void> resumeLiveScan() async {
    if (_cameraController == null || _liveService == null) return;
    await _cameraController!.startImageStream(_liveService!.processFrame);
    emit(LiveScanActiveState());
  }

  Future<void> stopLiveScan() async {
    _disposeLive();
    emit(LiveScanStoppedState());
  }

  void _disposeLive() {
    _liveSub?.cancel();
    _liveSub = null;
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _cameraController = null;
    _liveService?.dispose();
    _liveService = null;
  }
}
