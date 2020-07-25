import 'package:test_app_login/repositories/api_provider.dart';
import 'package:test_app_login/repositories/user_reporisory.dart';
import 'package:test_app_login/viewmodel/barcode_scan.dart';
import 'package:test_app_login/viewmodel/users_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => ApiProvider());
  locator.registerLazySingleton(() => UsersRepository());
  locator.registerFactory(() => UsersViewModel());
  locator.registerFactory(() => BarcodeScan());
}
