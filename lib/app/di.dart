import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_preferences.dart';
import 'file_picker.dart';

final instance = GetIt.instance;
Future<void> initAppModule() async {
  /* ------------------------------ Cache Module ------------------------------ */
  await initCacheModule();
  /* ----------------------------- Services Module ---------------------------- */
  await initServicesModule();
}

/* -------------------------------------------------------------------------- */
/*                               Services Module                              */
/* -------------------------------------------------------------------------- */
Future<void> initServicesModule() async {
  /* --------------------------- File Picker Service -------------------------- */
  instance.registerLazySingleton<AppFilePicker>(
      () => AppFilePicker(ImagePicker(), FilePicker.platform));
}

/* -------------------------------------------------------------------------- */
/*                                Cache Module                                */
/* -------------------------------------------------------------------------- */
Future<void> initCacheModule() async {
  final sharedPref = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPref);
  instance.registerLazySingleton<AppPreferences>(
      () => AppPreferences(instance<SharedPreferences>()));
}
