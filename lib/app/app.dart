import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../presentation/cubit/cubit.dart';
import '../presentation/cubit/states.dart';
import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';
import 'app_preferences.dart';
import 'di.dart';

class MyApp extends StatefulWidget {
  // ignore: empty_constructor_bodies
  MyApp._internal() {}

  static final MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _preferences = instance<AppPreferences>();
  Size _size = const Size(360, 690);
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.sizeOf(context);
    _preferences.getLocale().then(context.setLocale);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /* -------------------------------------------------------------------------- */
      /*                                Cubit Creator                               */
      /* -------------------------------------------------------------------------- */
      create: (context) => AppCubit(instance())
        ..loadModel()
        ..loadPlantsDetails(),
      /* -------------------------------------------------------------------------- */
      /*                                Child Builder                               */
      /* -------------------------------------------------------------------------- */
      child: ScreenUtilInit(
        designSize: _size,
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) => BlocBuilder<AppCubit, AppStates>(
          builder: (context, state) => MaterialApp.router(
            routerConfig: RouteGenerator.router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            builder: EasyLoading.init(),
          ),
        ),
      ),
    );
  }
}
