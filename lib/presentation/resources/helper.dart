import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plantdetection/app/extensions.dart';
import 'package:plantdetection/presentation/resources/app_strings.dart';
import 'package:plantdetection/presentation/resources/color_manager.dart';
import 'package:plantdetection/presentation/resources/values_manager.dart';

import '../../domain/models/models.dart';

class AppHelpers {
  /* -------------------------------------------------------------------------- */
  /*                          Show Picker Image Details                         */
  /* -------------------------------------------------------------------------- */
  static showPickedImageDetails(
    BuildContext context, {
    required File file,
    required PlantifyPrediction prediction,
    required PlantDetails details,
  }) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.white,
        barrierColor: Colors.black26,
        showDragHandle: true,
        builder: (ctx) {
          return ListView(
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
                        file,
                        height: AppSize.s220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              AppSize.s20.height,
              /* -------------------------------------------------------------------------- */
              /*                                Name Builder                                */
              /* -------------------------------------------------------------------------- */
              // Text(
              //   AppStrings.name.tr(),
              //   textAlign: TextAlign.start,
              //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //         color: ColorManager.lightGrey,
              //       ),
              // ),
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
          );
        });
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.primary,
                ),
          ),
          AppSize.s5.height,
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
