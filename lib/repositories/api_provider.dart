import 'dart:convert';
import 'package:test_app_login/models/users_model.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  Dio dio = Dio();
  String _apiUrl = "https://dijitalacentem.net/api.json";
  List<UsersDataModel> _usersList = [];

  Future<List<UsersDataModel>> getUsersFromApi() async {
    try {
      Response<String> response = await dio.get(_apiUrl);
      _usersList = (json.decode(response.data) as List)
          .map((toMap) => UsersDataModel.fromJson(toMap))
          .toList();
      print(response.statusCode);
    } on DioError catch (ex) {
      print(ex.error.toString());
      if (ex.type == DioErrorType.RESPONSE) {
        //404, 400, 500
        if (ex.response.statusCode == 404) {
          //Give warning Here
        }
      } else if (ex.type == DioErrorType.DEFAULT) {
        throw Exception(ex.error.message);
      } else {
        //timeout and canceled
      }
    }
    return _usersList;
  }
}
