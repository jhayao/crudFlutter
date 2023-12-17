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

  static Future setUser(User user) async=>
      await _preferences.setString('user', user.toJson().toString());


}