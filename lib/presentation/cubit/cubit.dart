import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantdetection/app/file_picker.dart';
import 'package:tflite/tflite.dart';
import '../../domain/models/models.dart';
import '../resources/helper.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit(this._filePicker) : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  final AppFilePicker _filePicker;
  onCloseApp() {}

  /* -------------------------------------------------------------------------- */
  /*                                 Load Model                                 */
  /* -------------------------------------------------------------------------- */
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/tflite/model.tflite",
      labels: "assets/tflite/labels.txt",
    );
    // interpreter.
  }

/* -------------------------------------------------------------------------- */
/*                             Load Plants Details                            */
/* -------------------------------------------------------------------------- */
  List<PlantDetails> plants = [];
  Future<void> loadPlantsDetails() async {
    final String response =
        await rootBundle.loadString('assets/tflite/plants_details.json');
    final data = await json.decode(response);
    plants = plantDetailsFromJson(json.encode(data));
  }

  PlantDetails getPlantByIndex(int index) =>
      plants.firstWhere((element) => element.index == index);

  /* -------------------------------------------------------------------------- */
  /*                              Recongnize Image                              */
  /* -------------------------------------------------------------------------- */
  Future<PlantifyPrediction?> recognizeImage(File file) async {
    var recognitions = await Tflite.runModelOnImage(
      path: file.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (recognitions == null || recognitions.isEmpty) return null;
    return PlantifyPrediction.fromJson(
      json.decode(
        json.encode(recognitions[0]),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                 Home Screen                                */
  /* -------------------------------------------------------------------------- */
  GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey();
  openHomeDrawer() => homeScaffoldKey.currentState?.openDrawer();

  /* ------------------------- Pick Image From Gallery ------------------------ */
  pickGalleryImage(BuildContext context) async {
    /* -------------------------------- Pick File ------------------------------- */
    _filePicker.pickSingleImage().then(
      (picked) async {
        if (picked != null) {
          /* -------------------------------- Run Model ------------------------------- */
          await recognizeImage(picked).then((prediction) {
            if (prediction != null) {
              /* --------------------- Show Bottom Sheet With Details --------------------- */
              AppHelpers.showPickedImageDetails(
                context,
                file: picked,
                prediction: prediction,
                details: getPlantByIndex(prediction.index),
              );
            }
          });
        }
      },
    );
  }

  /* ------------------------- Take a Photo From Camera ------------------------ */
  takePhotoFromCamera(BuildContext context) async {
    /* -------------------------------- Pick File ------------------------------- */
    _filePicker.catchCameraImage().then(
      (picked) async {
        
        if (picked != null) {
          final file = File(picked.path);
          /* -------------------------------- Run Model ------------------------------- */
          await recognizeImage(file).then((prediction) {
            if (prediction != null) {
              /* --------------------- Show Bottom Sheet With Details --------------------- */
              AppHelpers.showPickedImageDetails(
                context,
                file: file,
                prediction: prediction,
                details: getPlantByIndex(prediction.index),
              );
            }
          });
        }
      },
    );
  }
}
