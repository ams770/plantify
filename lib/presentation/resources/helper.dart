import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/models/models.dart';
import '../plant_details/plant_details_view.dart';

class AppHelpers {
  /* -------------------------------------------------------------------------- */
  /*                          Show Picker Image Details                         */
  /* -------------------------------------------------------------------------- */
  static Future showPickedImageDetails(
    BuildContext context, {
    required File? file,
    required PlantifyPrediction prediction,
    required PlantDetails details,
  }) => showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    scrollControlDisabledMaxHeightRatio: 0.8,
    showDragHandle: true,
    builder: (ctx) => PlantDetailsPage(
      plantImage: file,
      prediction: prediction,
      details: details,
    ),
  );
}
