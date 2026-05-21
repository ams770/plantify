import 'dart:io';

import '../../domain/models/models.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class LiveScanLoadingState extends AppStates {}

class LiveScanActiveState extends AppStates {}

class LiveScanDetectedState extends AppStates {
  final PlantifyPrediction result;
  final PlantDetails details;
  final File? plantImage;
  LiveScanDetectedState({
    required this.plantImage,
    required this.result,
    required this.details,
  });
}

class LiveScanStoppedState extends AppStates {}

class LiveScanErrorState extends AppStates {
  final String message;
  LiveScanErrorState(this.message);
}
