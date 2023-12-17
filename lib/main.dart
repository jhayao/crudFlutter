import 'dart:convert';

import 'package:crud/api/api.dart';
import 'package:crud/model/User.dart';
import 'package:crud/pages/auth_page.dart';
import 'package:crud/pages/splashScreen.dart';
import 'package:crud/screen/home.dart';
import 'package:flutter/material.dart';

import 'include/UserPreference.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  UserPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isAuth = false;
  late Future<void> authFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authFuture = checkAuth();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authFuture = checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: authFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else {
            if (isAuth) {
              return const HomeScreen();
            } else {
              return const AuthPage();
            }
          }
        },
      ),
    );
  }

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    // UserPreference.removeToken();
    // UserPreference.setToken("20|XKpzJjjxe2FTgUraMkJACZUXBkN5C5gpwL7otqzS6769a6ef");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await UserPreference.getToken()}'
    };
    // print(headers);
    final response = await CallApi().getData('auth\\checkAuth', headers: headers);
    final body = response.body;
    final result = jsonDecode(body);
    if (result['success'] != null && result['success']) {
      setState(() {
        isAuth = true;
      });
    }
  }
}
