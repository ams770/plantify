/* -------------------------------------------------------------------------- */
/*                                 App Button                                 */
/* -------------------------------------------------------------------------- */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_manager.dart';
import 'constants_manager.dart';
import 'font_manager.dart';
import 'values_manager.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color,
      this.height,
      this.maxWidth});
  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final double? height;
  final double? maxWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: AppSize.s60,
        maxWidth: maxWidth ?? AppConstants.maxScreenWidth.w,
      ),
      child: Center(
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: AppConstants.maxScreenWidth.w,
          height: height,
          color: color ?? ColorManager.primary,
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorManager.white,
                  fontWeight: FontWeightManager.medium,
                ),
          ),
        ),
      ),
    );
  }
}
