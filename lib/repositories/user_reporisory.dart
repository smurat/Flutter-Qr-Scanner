import 'package:test_app_login/helpers/locator.dart';
import 'package:test_app_login/models/users_model.dart';
import 'package:test_app_login/repositories/api_provider.dart';

class UsersRepository {
  ApiProvider _provider = locator<ApiProvider>();

  Future<List<UsersDataModel>> get getUsersDatas async =>
      await _provider.getUsersFromApi();
}
