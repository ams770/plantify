import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/extensions.dart';
import '../../domain/models/models.dart';
import '../resources/app_strings.dart';
import '../resources/color_manager.dart';
import '../resources/values_manager.dart';

class PlantDetailsPage extends StatelessWidget {
  const PlantDetailsPage({
    super.key,
    required this.plantImage,
    required this.prediction,
    required this.details,
  });
  final File plantImage;
  final PlantifyPrediction prediction;
  final PlantDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* -------------------------------------------------------------------------- */
          /*                                Image Builder                               */
          /* -------------------------------------------------------------------------- */
          Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s10),
                  ),
                  child: Image.file(
                    plantImage,
                    height: AppSize.s220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          AppSize.s20.height,
          Text(
            details.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          AppSize.s20.height,

          /* -------------------------------------------------------------------------- */
          /*                               Scientific Name                              */
          /* -------------------------------------------------------------------------- */
          _ItemBuilder(
            title: AppStrings.scientificName.tr(),
            value: details.scientificName,
          ),

          /* -------------------------------------------------------------------------- */
          /*                              Accuracy Builder                              */
          /* -------------------------------------------------------------------------- */
          // _ItemBuilder(
          //   title: AppStrings.accuracy.tr(),
          //   value: (prediction.confidence * 100).ceil().toString(),
          // ),

          /* -------------------------------------------------------------------------- */
          /*                                 Description                                */
          /* -------------------------------------------------------------------------- */
          _ItemBuilder(
            title: AppStrings.description.tr(),
            value: details.description,
          ),

          /* -------------------------------------------------------------------------- */
          /*                              Care Instructions                             */
          /* -------------------------------------------------------------------------- */
          _ItemBuilder(
            title: AppStrings.careInstructions.tr(),
            value: details.careInstructions,
          ),

          AppSize.s20.height,
        ],
      ),
    );
  }
}

class _ItemBuilder extends StatelessWidget {
  const _ItemBuilder({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p15,
      ),
      margin: const EdgeInsets.only(bottom: AppMargin.m10),
      decoration: BoxDecoration(
        color: ColorManager.offWhite.withOpacity(0.3),
        border: Border.all(color: ColorManager.offWhite),
        borderRadius: BorderRadius.circular(AppSize.s10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ColorManager.primary),
          ),
          AppSize.s5.height,
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
