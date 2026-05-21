import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/extensions.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../resources/app_strings.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/constants_manager.dart';
import '../resources/values_manager.dart';
import 'live_scan_view.dart';

part 'widgets/home_header.dart';
part 'widgets/home_option_builder.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext ctx) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return PopScope(
          canPop: false,
          /* ------------------------------ On Close App ------------------------------ */
          onPopInvoked: (_) => cubit.onCloseApp(),
          /* ----------------------------- Screen Builder ----------------------------- */
          child: Scaffold(
            key: cubit.homeScaffoldKey,
            backgroundColor: ColorManager.offWhite,
            extendBodyBehindAppBar: true,
            extendBody: true,
            /* -------------------------------------------------------------------------- */
            /*                                    Body                                    */
            /* -------------------------------------------------------------------------- */
            body: CustomScrollView(
              slivers: [
                SliverPersistentHeader(delegate: _HomeViewHeaderDelegate()),

                /* ---------------------------- Pick From Gallery --------------------------- */
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p20,
                    vertical: AppPadding.p40,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _HomeOptionBuilder(
                        title: AppStrings.liveDetection.tr(),
                        subTitle: AppStrings.liveDetectionDesc.tr(),
                        svg: SVGAssets.live,
                        onTap: () => Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => LiveScanScreen(),
                              ),
                            )
                            .then((_) => cubit.stopLiveScan()),
                      ),
                      AppSize.s20.height,
                      _HomeOptionBuilder(
                        title: AppStrings.pickFromGallery.tr(),
                        subTitle: AppStrings.pickFromGalleryDesc.tr(),
                        svg: SVGAssets.gallery,
                        onTap: () => cubit.pickGalleryImage(context),
                      ),
                      AppSize.s20.height,
                      /* ------------------------- Using Augmanted Reality ------------------------ */
                      _HomeOptionBuilder(
                        title: AppStrings.takePhoto.tr(),
                        subTitle: AppStrings.takePhotoDesc.tr(),
                        svg: SVGAssets.openCamera,
                        onTap: () => cubit.takePhotoFromCamera(context),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
