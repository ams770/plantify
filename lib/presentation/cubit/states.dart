import '../../app/plan_live_detection.dart';
import '../../domain/models/models.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class LiveScanLoadingState extends AppStates {}

class LiveScanActiveState extends AppStates {}

class LiveScanDetectedState extends AppStates {
  final PlantLiveResult result;
  final PlantDetails details;
  LiveScanDetectedState({required this.result, required this.details});
}

class LiveScanStoppedState extends AppStates {}

class LiveScanErrorState extends AppStates {
  final String message;
  LiveScanErrorState(this.message);
}
