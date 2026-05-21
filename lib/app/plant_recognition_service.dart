import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as image_lib;
import 'package:plantdetection/domain/models/models.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'plan_live_detection.dart';

abstract class IPlantRecognitionService {
  Future<PlantifyPrediction?> recognizeImage(File file);

  List<PlantDetails> get plants;

  Future<PlantLiveDetectionService> startLiveDetection();

  void dispose();
}

class PlantRecognitionService implements IPlantRecognitionService {
  PlantRecognitionService._();

  static Future<PlantRecognitionService> create() async {
    final service = PlantRecognitionService._();
    await Future.wait([service._loadModel(), service._loadPlantsDetails()]);
    return service;
  }

  Interpreter? _interpreter;
  List<String> _labels = [];

  int _inputHeight = 224;
  int _inputWidth = 224;

  static const double _imageMean = 127.5;
  static const double _imageStd = 127.5;
  static const double _confidenceThreshold = 0.6;

  /* -------------------------------------------------------------------------- */
  /*                                 Load Model                                 */
  /* -------------------------------------------------------------------------- */
  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/tflite/model.tflite',
      options: InterpreterOptions()..threads = 4,
    );

    final inputShape = _interpreter!.getInputTensor(0).shape;
    _inputHeight = inputShape[1];
    _inputWidth = inputShape[2];

    final raw = await rootBundle.loadString('assets/tflite/labels.txt');
    _labels = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  /* -------------------------------------------------------------------------- */
  /*                             Load Plants Details                            */
  /* -------------------------------------------------------------------------- */
  List<PlantDetails> _plants = [];

  List<PlantDetails> get plants => _plants;

  Future<void> _loadPlantsDetails() async {
    final String response = await rootBundle.loadString(
      'assets/tflite/plants_details.json',
    );
    final data = await json.decode(response);
    _plants = plantDetailsFromJson(json.encode(data));
  }

  /* -------------------------------------------------------------------------- */
  /*                              Recognize Image                               */
  /* -------------------------------------------------------------------------- */
  @override
  Future<PlantifyPrediction?> recognizeImage(File file) async {
    if (_interpreter == null) return null;

    final bytes = await file.readAsBytes();
    final image = image_lib.decodeImage(bytes);
    if (image == null) return null;

    final resized = image_lib.copyResize(
      image,
      width: _inputWidth,
      height: _inputHeight,
    );

    final inputTensor = [
      List.generate(
        _inputHeight,
        (y) => List.generate(_inputWidth, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            (pixel.r.toDouble() - _imageMean) / _imageStd,
            (pixel.g.toDouble() - _imageMean) / _imageStd,
            (pixel.b.toDouble() - _imageMean) / _imageStd,
          ];
        }),
      ),
    ];

    final outputTensor = [List<double>.filled(_labels.length, 0.0)];

    _interpreter!.run(inputTensor, outputTensor);

    int bestIndex = -1;
    double bestScore = _confidenceThreshold;

    final scores = outputTensor[0];
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }

    if (bestIndex == -1) return null;

    return PlantifyPrediction.fromJson({
      'index': bestIndex,
      'label': _labels[bestIndex],
      'confidence': bestScore,
    });
  }

  @override
  Future<PlantLiveDetectionService> startLiveDetection() =>
      PlantLiveDetectionService.start(
        interpreter: _interpreter!, // Shared by address — zero extra RAM
        labels: _labels,
        inputWidth: _inputWidth,
        inputHeight: _inputHeight,
      );

  /* -------------------------------------------------------------------------- */
  /*                                  Dispose                                   */
  /* -------------------------------------------------------------------------- */
  @override
  void dispose() => _interpreter?.close();
}
