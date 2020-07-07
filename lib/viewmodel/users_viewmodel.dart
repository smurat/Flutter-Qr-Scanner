import 'dart:convert';
import 'package:test_app_login/helpers/locator.dart';
import 'package:test_app_login/models/users_model.dart';
import 'package:test_app_login/repositories/user_reporisory.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UsersDataState {
  InitialState,
  UsersDataLoading,
  UsersDataLoaded,
  UsersDataError,
}

class UsersViewModel with ChangeNotifier {
  Map<String, dynamic> userFormMap = Map();
  UsersDataState _usersState;
  List<UsersDataModel> _usersData;
  UsersRepository _repository;
  bool _sortAZ;

  UsersViewModel() {
    _repository = locator<UsersRepository>();
    _usersState = UsersDataState.InitialState;
    _sortAZ = false;
  }

  UsersRepository get repository => _repository;

  List<UsersDataModel> get usersData => _usersData;

  set usersData(List<UsersDataModel> value) {
    _usersData = value;
    notifyListeners();
  }

  UsersDataState get state => _usersState;

  set state(UsersDataState value) {
    _usersState = value;
    notifyListeners();
  }

  bool get sortList => _sortAZ;

  set sortList(bool value) {
    if (!_sortAZ) {
      usersData.sort((a, b) => a.name.compareTo(b.name));
    } else
      usersData = usersData.reversed.toList();
    _sortAZ = value;
    notifyListeners();
  }

  Future<List<UsersDataModel>> getUsersData() async {
    try {
      state = UsersDataState.UsersDataLoading;
      _usersData = await _repository.getUsersDatas;
      state = UsersDataState.UsersDataLoaded;
      usersData = _usersData.where((f) => f.isActive).toList();
    } catch (e) {
      print(e);
      state = UsersDataState.UsersDataError;
    }
    return _usersData;
  }

  Future<Map<String, dynamic>> saveUser({String email, String password}) async {
    final prefs = await SharedPreferences.getInstance();
    userFormMap["email"] = email;
    userFormMap["password"] = password;
    String sharedPrefUser = json.encode(userFormMap);
    prefs.setString("loginData", sharedPrefUser);
    return userFormMap;
  }

  Future<bool> checkLoginDataExist() async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.containsKey("loginData");
    return value;
  }

  Future<Map<String, dynamic>> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    bool keyExist = prefs.containsKey("loginData");
    String rawData = prefs.getString("loginData");
    Map<String, dynamic> loginData = keyExist ? jsonDecode(rawData) : Map();
    return loginData;
  }

  Future deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    bool userExist = await checkLoginDataExist();
    if (userExist) {
      await prefs.remove("loginData");
    } else
      print("User already deleted");

    //Alternative Delete
/*     var keys = prefs.getKeys();
    for (String key in keys) {
      print(key);
      if (key == "loginData") {
       await prefs.remove(key);
      }
    } */
  }
}
