import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'app/app.dart';
import 'app/bloc_observer.dart';
import 'app/di.dart';
import 'presentation/resources/language_manager.dart';
import 'presentation/resources/popus_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* ------------------------ Preent App From Rotating ------------------------ */
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /* ----------------------------- Hide Status Bar ---------------------------- */
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

  await Future.wait(
    [
      EasyLocalization.ensureInitialized(),
      initAppModule(),
    ],
  );

  PopupsManager.init();
  Bloc.observer = MyBlocObserver();

  runApp(
    Phoenix(
      child: EasyLocalization(
        path: ASSET_PATH_LOCALISATION,
        supportedLocales: const [ENGLISH_LOCALE],
        child: MyApp(),
      ),
    ),
  );
}

// 18 Calendula
// 14 BlackeyedSusan
