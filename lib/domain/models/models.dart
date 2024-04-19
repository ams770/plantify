// To parse this JSON data, do
//
//     final plantDetails = plantDetailsFromJson(jsonString);

import 'dart:convert';

/* -------------------------------------------------------------------------- */
/*                             Plant Details Model                            */
/* -------------------------------------------------------------------------- */
List<PlantDetails> plantDetailsFromJson(String str) => List<PlantDetails>.from(
    json.decode(str).map((x) => PlantDetails.fromJson(x)));

String plantDetailsToJson(List<PlantDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlantDetails {
  final int index;
  final String name;
  final String scientificName;
  final String description;
  final String careInstructions;
  // final String image;

  PlantDetails({
    required this.index,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.careInstructions,
    // required this.image,
  });

  factory PlantDetails.fromJson(Map<String, dynamic> json) => PlantDetails(
        index: json["index"],
        name: json["name"] ?? "",
        scientificName: json["scientificName"] ?? "",
        description: json["description"] ?? "",
        careInstructions: json["careInstructions"] ?? "",
        // image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "name": name,
        "scientificName": scientificName,
        "description": description,
        "careInstructions": careInstructions,
        // "image": image,
      };
}

/* -------------------------------------------------------------------------- */
/*                               PredictionModel                              */
/* -------------------------------------------------------------------------- */

PlantifyPrediction plantifyPredictionFromJson(String str) =>
    PlantifyPrediction.fromJson(json.decode(str));

String plantifyPredictionToJson(PlantifyPrediction data) =>
    json.encode(data.toJson());

class PlantifyPrediction {
  final double confidence;
  final int index;
  final String label;

  PlantifyPrediction({
    required this.confidence,
    required this.index,
    required this.label,
  });

  factory PlantifyPrediction.fromJson(Map<String, dynamic> json) =>
      PlantifyPrediction(
        confidence: json["confidence"],
        index: json["index"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "index": index,
        "label": label,
      };
}
