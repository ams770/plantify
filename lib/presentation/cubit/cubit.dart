import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdetection/app/file_picker.dart';

import '../../app/plant_recognition_service.dart';
import '../../domain/models/models.dart';
import '../resources/helper.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(this._filePicker, this._recognitionService)
    : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  final AppFilePicker _filePicker;
  final IPlantRecognitionService _recognitionService;

  void onCloseApp() => _recognitionService.dispose();

  PlantDetails getPlantByIndex(int index) => _recognitionService.plants
      .firstWhere((element) => element.index == index);

  /* -------------------------------------------------------------------------- */
  /*                                 Home Screen                                */
  /* -------------------------------------------------------------------------- */
  GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey();

  void openHomeDrawer() => homeScaffoldKey.currentState?.openDrawer();

  /* ------------------------- Pick Image From Gallery ------------------------ */
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

  /* ------------------------- Take a Photo From Camera ----------------------- */
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
}
