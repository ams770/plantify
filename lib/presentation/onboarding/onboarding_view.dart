import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:plantdetection/app/extensions.dart';
import 'package:plantdetection/presentation/cubit/cubit.dart';
import 'package:plantdetection/presentation/resources/color_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../resources/app_strings.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';
import '../resources/widgets.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // instance<AppPreferences>().setFirstOpen();
  }

  _goNext() {
    if ((_pageController.page ?? 0) < 2) {
      _pageController.nextPage(duration: _duration, curve: Curves.ease);
    } else {
      /* ---------------------------------- Go To Home ---------------------------------- */
      context.replace(Routes.homeRoute);
    }
  }

  _goPrevious() =>
      _pageController.previousPage(duration: _duration, curve: Curves.ease);

  get _duration => const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) {
        if ((_pageController.page ?? 0) > 0) {
          _goPrevious();
        } else {
          AppCubit.get(context).onCloseApp();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView(
                controller: _pageController,
                children: [
                  /* ----------------------------- Onboarding One ----------------------------- */
                  _OnboardnigBuilder(
                    title: AppStrings.onboardingTitleOne.tr(),
                    message: AppStrings.onboardingMessageOne.tr(),
                    svg: SVGAssets.onboardingOne,
                  ),
                  /* ----------------------------- Onboarding Two ----------------------------- */
                  _OnboardnigBuilder(
                    title: AppStrings.onboardingTitleTwo.tr(),
                    message: AppStrings.onboardingMessageTwo.tr(),
                    svg: SVGAssets.onboardingTwo,
                  ),
                  /* ----------------------------- Onboarding Three ----------------------------- */
                  _OnboardnigBuilder(
                    title: AppStrings.onboardingTitleThree.tr(),
                    message: AppStrings.onboardingMessageThree.tr(),
                    svg: SVGAssets.onboardingThree,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  /* -------------------------------- Page Indicator ------------------------------- */
                  SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: ColorManager.primary,
                      dotColor: ColorManager.offWhite,
                    ), // your preferred effect
                  ),
                  AppSize.s40.height,
                  /* ------------------------------ Bottom Button ----------------------------- */
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p20,
                    ),
                    child: AppButton(
                      onPressed: _goNext,
                      text: AppStrings.next.tr(),
                    ),
                  ),
                ],
              ),
            ),
            AppSize.s20.height,
          ],
        ),
      ),
    );
  }
}

class _OnboardnigBuilder extends StatelessWidget {
  const _OnboardnigBuilder({
    required this.title,
    required this.message,
    required this.svg,    
  });
  final String title;
  final String message;
  final String svg;  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SvgPicture.asset(
          svg,
          fit: BoxFit.contain,
          height: AppSize.s300,
        ),        

        /* ------------------------------ Title Builder ----------------------------- */
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: ColorManager.primary),
        ),
        AppSize.s10.height,

        /* ------------------------------ Message Builder ----------------------------- */
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p10,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: ColorManager.lightGrey),
          ),
        ),
      ],
    );
  }
}
