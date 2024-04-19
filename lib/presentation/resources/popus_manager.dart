import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'color_manager.dart';
import 'values_manager.dart';

class PopupsManager {


  static init() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.foldingCube
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = AppSize.s50
      ..radius = AppSize.s7
      ..maskType = EasyLoadingMaskType.black
      ..progressColor = ColorManager.primary
      ..indicatorColor = ColorManager.primary
      ..backgroundColor = ColorManager.white
      ..textColor = ColorManager.primary
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  static void showLoadingDialog() {
    EasyLoading.show();
    //status: "${AppStrings.loading.tr()}..."
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }

  static showSuccess() {
    dismiss();
    EasyLoading.showSuccess("", dismissOnTap: true);
  }

  static showProgressIndicator(int progress) {
    if (progress == 100) {
      EasyLoading.dismiss();
    } else {
      init();
      EasyLoading.showProgress(
        progress / 100,
        status: "...",
      );
    }
  }

  static showExceptionDialog(String message) {
    dismiss();
    EasyLoading.showError(
      message,
      duration: const Duration(seconds: 2),
      dismissOnTap: true,
    );
  }
}
