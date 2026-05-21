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
    final textTheme = Theme.of(context).textTheme;
    final double confidencePercentage = (prediction.confidence * 100).clamp(
      0,
      100,
    );

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p24,
          vertical: AppPadding.p10,
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Small reference image
              Hero(
                tag: plantImage.path,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s16),
                  child: Image.file(
                    plantImage,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: AppSize.s16),

              // Text and Badge Stack
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      details.name,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    /* Friendly Match Badge */
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppSize.s20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: ColorManager.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${confidencePercentage.ceil()}% ${AppStrings.accuracy}",
                            style: textTheme.bodySmall?.copyWith(
                              color: ColorManager.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(
            height: AppSize.s40,
            color: ColorManager.lightPrimary.withOpacity(0.5),
          ),

          /* -------------------------------------------------------------------------- */
          /* --- Description Section ---                                               */
          /* -------------------------------------------------------------------------- */
          _SectionHeader(
            title: AppStrings.description.tr(),
            icon: Icons.info_outline,
          ),
          const SizedBox(height: AppSize.s10),
          Text(
            details.description,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppPadding.p24),

          /* -------------------------------------------------------------------------- */
          /* --- Care Instructions Section ---                                         */
          /* -------------------------------------------------------------------------- */
          _SectionHeader(
            title: AppStrings.careInstructions.tr(),
            icon: Icons.eco_outlined,
          ),
          const SizedBox(height: AppSize.s10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppPadding.p16),
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSize.s16),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 4, color: ColorManager.primary),
                ),
              ),
              padding: const EdgeInsets.only(left: AppPadding.p12),
              child: Text(
                details.careInstructions,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SafeArea(child: SizedBox(height: AppSize.s20)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: ColorManager.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorManager.primary,
          ),
        ),
      ],
    );
  }
}
