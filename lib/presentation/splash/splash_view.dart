import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_preferences.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/constants_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool visible = false;

  _startDelay() async {
    final preferences = instance<AppPreferences>();

    bool isFirstOpen = preferences.isFirstOpen;

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      visible = true;
    });

    _timer = Timer(
        const Duration(
          seconds: AppConstants.splashDelay,
        ), () {
      _goNext(isFirstOpen);
    });
  }

  _goNext(bool isFirstOpen) async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    if (isFirstOpen) {
      /* ---------------------------- Go To OnBoarding ---------------------------- */
      context.push(Routes.onBoardingRoute);
    } else {
      /* ---------------------------------- Home ---------------------------------- */
      context.replace(Routes.homeRoute);
    }
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    // _controller.dispose();
  }

  Color get firstColor =>
      visible ? ColorManager.secondary : ColorManager.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        toolbarHeight: AppSize.s0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Align(
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0.0,
          duration: const Duration(milliseconds: 1200),
          child: Image.asset(
            ImageAssets.logo,
            width: AppSize.s250.w,
          ),
        ),
      ),
    );
  }
}
