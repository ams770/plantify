import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'styles_manager.dart';
import 'values_manager.dart';

ThemeData get lightTheme => ThemeData(
      // primaryColor: ColorManager.primary,
      // splashColor: Colors.transparent,
      // primaryColorLight: ColorManager.lightPrimary,
      // primaryColorDark: ColorManager.darkPrimary,
      // disabledColor: ColorManager.grey,
      // scaffoldBackgroundColor: Colors.white,

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        modalBackgroundColor: Colors.white,
        surfaceTintColor: ColorManager.white,
        modalBarrierColor: ColorManager.offWhite.withOpacity(0.1),
      ),
      popupMenuTheme: PopupMenuThemeData(
        textStyle: getRegularStyle(
          fontSize: FontSize.s16,
          color: ColorManager.grey,
        ),
      ),

      timePickerTheme: const TimePickerThemeData(
        backgroundColor: ColorManager.white,
      ),

      dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: getRegularStyle(
            color: ColorManager.white,
            fontSize: FontSize.s13.sp,
            height: 1.5,
          ),
          menuStyle: MenuStyle(
            backgroundColor:
                MaterialStateProperty.all(ColorManager.deepDarkGrey),
          ),
          inputDecorationTheme: InputDecorationTheme(
            prefixStyle: getRegularStyle(
              color: ColorManager.white,
              fontSize: FontSize.s13.sp,
              height: 1.5,
            ),
            suffixStyle: getRegularStyle(
              color: ColorManager.white,
              fontSize: FontSize.s13.sp,
              height: 1.5,
            ),
          )),

      colorScheme: const ColorScheme(
        background: ColorManager.white,

        brightness: Brightness.light,
        error: ColorManager.error,
        onBackground: ColorManager.white,
        onError: ColorManager.error,
        onPrimary: ColorManager.offWhite,
        onSecondary: ColorManager.offWhite,

        primary: ColorManager.primary,
        secondary: ColorManager.secondary,
        // dialogs
        surface: ColorManager.offWhite,
        onSurface: ColorManager.grey,
      ),

      dialogTheme: const DialogTheme(
        backgroundColor: ColorManager.white,
        surfaceTintColor: ColorManager.white,
      ),

      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        labelPadding: const EdgeInsets.symmetric(vertical: AppPadding.p10),
        indicatorColor: ColorManager.primary,
        labelColor: ColorManager.primary,
        unselectedLabelColor: ColorManager.grey,
      ),

      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all<Color>(ColorManager.primary),
      ),

      //card theme
      cardTheme: CardTheme(
        color: ColorManager.white,
        shadowColor: ColorManager.offWhite,
        surfaceTintColor: ColorManager.offWhite,
        elevation: 0.6,
        clipBehavior: Clip.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorManager.white),
      )),

      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(ColorManager.primary),
        side: const BorderSide(color: ColorManager.offWhite),
      ),

      //app bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: AppSize.s0,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: kIsWeb ? ColorManager.primary : null,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: getBoldStyle(
          fontSize: FontSize.s23.sp,
          color: ColorManager.primary,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: ColorManager.primary,
        scrimColor: ColorManager.offWhite,
        elevation: 1,
      ),

      // button theme
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s7)),
        height: kIsWeb ? AppSize.s60.h : AppSize.s45.h,
        focusColor: ColorManager.primary,
        splashColor: ColorManager.offWhite,
        buttonColor: ColorManager.primary,
        disabledColor: ColorManager.grey,
      ),

      //elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          textStyle: getRegularStyle(
            color: ColorManager.white,
            fontSize: FontSize.s15.sp,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s4),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          textStyle: MaterialStateProperty.all<TextStyle>(
            getMediumStyle(
              // signup hint
              fontSize: FontSize.s14.sp,
              color: ColorManager.deepDarkGrey,
            ),
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ColorManager.primary,
        unselectedItemColor: ColorManager.grey.withOpacity(0.4),
        backgroundColor: ColorManager.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // text theme

      textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(
          // App Name Splash
          fontSize: FontSize.s45.sp,
          color: ColorManager.darkGrey,
        ),
        displayMedium: getSemiBoldStyle(
          // signup header
          fontSize: FontSize.s32.sp,
          color: ColorManager.primary,
        ),
        displaySmall: getMediumStyle(
          // signup header
          fontSize: FontSize.s17.sp,
          color: ColorManager.darkGrey,
        ),
        headlineLarge: getSemiBoldStyle(
          fontSize: FontSize.s30.sp,
          color: ColorManager.darkGrey,
        ),
        headlineMedium: getBoldStyle(
          fontWeight: FontWeightManager.extraBold,
          fontSize: FontSize.s26.sp,
          color: ColorManager.darkGrey,
        ),
        headlineSmall: getBoldStyle(
          fontSize: FontSize.s20.sp,
          color: ColorManager.darkGrey,
        ),
        titleLarge: getMediumStyle(
          fontSize: FontSize.s15.sp,
          color: ColorManager.deepDarkGrey,
        ),
        titleMedium: getMediumStyle(
          // signup hint
          fontSize: FontSize.s14.sp,
          color: ColorManager.deepDarkGrey,
        ),
        bodyLarge: getRegularStyle(
          color: ColorManager.deepDarkGrey,
          fontSize: FontSize.s15.sp,
        ),
        bodyMedium: getRegularStyle(
          color: ColorManager.deepDarkGrey,
          fontSize: FontSize.s14.sp,
          height: 1.5,
        ),
        bodySmall: getRegularStyle(
          color: ColorManager.deepDarkGrey,
          fontSize: FontSize.s12.sp,
        ),
        labelSmall: getRegularStyle(
          color: ColorManager.offWhite,
          fontSize: FontSize.s9_3.sp,
        ),
      ),

      // input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppPadding.p15,
          vertical: AppPadding.p10.h,
        ),

        hintStyle: getRegularStyle(
          color: ColorManager.lightGrey,
          fontSize: FontSize.s16.sp,
          height: 1.9,
        ),

        labelStyle: getRegularStyle(
          color: ColorManager.lightGrey,
          fontSize: FontSize.s15.sp,
        ),
        errorStyle: getRegularStyle(
          color: ColorManager.error,
        ),

        prefixIconColor: ColorManager.lightGrey,
        suffixIconColor: ColorManager.offWhite,

        // border
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: AppSize.s1,
            color: ColorManager.primary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s10)),
        ),

        focusedBorder: OutlineInputBorder(
          // gapPadding: 50,
          borderSide: const BorderSide(
            color: ColorManager.primary,
          ),
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        disabledBorder: OutlineInputBorder(
          // gapPadding: 50,
          borderSide: const BorderSide(
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(AppSize.s10),
        ),
        enabledBorder: OutlineInputBorder(
          // gapPadding: 50,
          borderRadius: BorderRadius.circular(AppSize.s10),
          borderSide: const BorderSide(color: ColorManager.white),
        ),

        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: AppSize.s1,
            color: ColorManager.error,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s10),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: ColorManager.white),
    );
