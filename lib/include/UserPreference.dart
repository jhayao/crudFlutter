// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/User.dart';

class UserPreference {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setToken(String token) async =>
      await _preferences.setString('token', token);

  static Future getToken() async =>
      _preferences.getString('token');

  static Future removeToken() async =>
      await _preferences.remove('token');

  static Future setUserRole(int role) async =>
      await _preferences.setInt('role', role);

  static Future removeUserRole() async =>
      await _preferences.remove('role');

  static Future<int> getUserRole() async =>
      _preferences.getInt('role') ?? 0;

  static Future setUserId(int id) async =>
      await _preferences.setInt('id', id);

  static Future removeUserId() async =>
      await _preferences.remove('id');

  static Future getUserId() async =>
      _preferences.getInt('id');

  static Future setUser(User user) async =>
      await _preferences.setString('user', json.encode(user.toJson()));

  static Future removeUser() async =>
      await _preferences.remove('user');

  static Future<User> getUser() async {
    final userString = _preferences.getString('user');
    print(userString);
    if (userString != null) {
      return User.fromJson(json.decode(userString));
    } else {
      return User(
          name: "User Not Found",
          email: "User Not Found",
          student_name: "User Not Found",
          student_id: 0,
          student_phone: "User Not Found",
          student_address: "User Not Found");
    }
  }


}