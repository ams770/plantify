import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantdetection/app/extensions.dart';
import 'package:plantdetection/presentation/resources/app_strings.dart';
import 'package:plantdetection/presentation/resources/color_manager.dart';
import 'package:plantdetection/presentation/resources/constants_manager.dart';
import 'package:plantdetection/presentation/resources/font_manager.dart';
import 'package:plantdetection/presentation/resources/values_manager.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../resources/assets_manager.dart';

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
          child: Stack(
            children: [
              /* --------------------------- Background Builder --------------------------- */
              SvgPicture.asset(
                SVGAssets.background,
                alignment: Alignment.topCenter,
                // color: ColorManager.primary,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                key: cubit.homeScaffoldKey,

                /* -------------------------------------------------------------------------- */
                /*                                   App Bar                                  */
                /* -------------------------------------------------------------------------- */
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  leading: GestureDetector(
                    onTap: cubit.openHomeDrawer,
                    child: const Icon(
                      CupertinoIcons.line_horizontal_3_decrease,
                      color: ColorManager.white,
                    ),
                  ),
                ),
                /* -------------------------------------------------------------------------- */
                /*                                   Drawer                                   */
                /* -------------------------------------------------------------------------- */
                drawer: Drawer(
                  child: ListView(
                    children: [
                      AppSize.s70.h.height,
                      /* ---------------------------------- Title --------------------------------- */
                      Text(
                        AppStrings.setttings.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: ColorManager.white),
                      ),
                      AppSize.s50.height,
                      /* ------------------------------ App Language ------------------------------ */
                      _DrawerItemBuilder(
                        title: AppStrings.appLanguage.tr(),
                        icon: Icons.language_rounded,
                        onTap: () {},
                      ),
                      AppSize.s20.height,
                      const _HorizontalSeperator(),
                      AppSize.s20.height,
                      /* ------------------------------ Hostory ------------------------------ */
                      _DrawerItemBuilder(
                        title: AppStrings.history.tr(),
                        icon: CupertinoIcons.table_badge_more,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                /* -------------------------------------------------------------------------- */
                /*                                    Body                                    */
                /* -------------------------------------------------------------------------- */
                body: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                  children: [
                    (MediaQuery.sizeOf(context).height / 5).height,
                    /* ---------------------------- Pick From Gallery --------------------------- */
                    _HomeItemBuilder(
                      title: AppStrings.pickFromGallery.tr(),
                      subTitle: '',
                      svg: SVGAssets.gallery,
                      onTap: () => cubit.pickGalleryImage(context),
                    ),
                    AppSize.s20.height,
                    /* ------------------------- Using Augmanted Reality ------------------------ */
                    _HomeItemBuilder(
                      title: AppStrings.takePhoto.tr(),
                      subTitle: '',
                      svg: SVGAssets.augmantedReality,
                      onTap: () => cubit.takePhotoFromCamera(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeItemBuilder extends StatelessWidget {
  const _HomeItemBuilder({
    required this.title,
    required this.subTitle,
    required this.svg,
    required this.onTap,
  });
  final String title;
  final String subTitle;
  final String svg;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.maxScreenWidth,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s10),
          color: ColorManager.offWhite,
        ),
        child: Row(
          children: [
            /* ------------------------------- SVG Builder ------------------------------ */
            SvgPicture.asset(
              svg,
              height: AppSize.s120,
            ),
            /* ------------------------------ Title Builder ----------------------------- */
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HorizontalSeperator extends StatelessWidget {
  const _HorizontalSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s0_5,
      width: double.infinity,
      color: ColorManager.offWhite,
    );
  }
}

class _DrawerItemBuilder extends StatelessWidget {
  const _DrawerItemBuilder(
      {required this.title, required this.icon, required this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ColorManager.white,
            size: AppSize.s23,
          ),
          AppSize.s15.width,
          SizedBox(
            width: AppSize.s110,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorManager.white,
                    fontWeight: FontWeightManager.semiBold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
