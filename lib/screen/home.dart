import 'dart:convert';

import 'package:crud/api/api.dart';
import 'package:crud/include/UserPreference.dart';
import 'package:crud/screen/event/default.dart';
import 'package:crud/screen/student/default.dart';
import 'package:crud/screen/profile.dart';
import 'package:crud/screen/setting.dart';
import 'package:crud/screen/student/createStudent.dart';
import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../model/User.dart';
import 'User/account.dart';
import 'attendance/studentAttendance.dart';
import 'event.dart';
import 'event/createEvent.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _bottomNavIndex = 0;
  final globalKey = GlobalKey<DefaultPageState>();
  final globalKeyEvent = GlobalKey<EventDefaultPageState>();
  User? user;
  late Future<int> userRole;
  final iconList = <IconData>[
    Icons.home,
    Icons.calendar_month,
    Icons.settings,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
    userRole = getRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userRole,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Widget> _children = [
              snapshot.data == 0
                  ? DefaultPage(key: globalKey)
                  : const StudentAttendance(),
              EventDefaultPage(key: globalKeyEvent),
              const AboutPage(),
              AccountPage(user: user),
            ];
            return MaterialApp(
              home: Scaffold(
                body: _children[_bottomNavIndex],
                floatingActionButton: Visibility(
                  visible: (snapshot.data == 0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.redAccent,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    onPressed: () {
                      if (_bottomNavIndex == 0) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => createStudent(
                                  notifyParent: fetchStudent,
                                )));
                      } else if (_bottomNavIndex == 1) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => createEvent(
                                  notifyParent: fetchEvent,
                                )));
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: AnimatedBottomNavigationBar(
                  activeIndex: _bottomNavIndex,
                  inactiveColor: Colors.grey,
                  activeColor: Colors.redAccent,
                  icons: iconList,
                  gapLocation: GapLocation.center,
                  backgroundColor: Colors.blueAccent,
                  notchSmoothness: NotchSmoothness.softEdge,
                  onTap: (index) => setState(() => _bottomNavIndex = index),
                  //other params
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void fetchStudent() {
    globalKey.currentState?.fetchStudent();
  }

  void fetchEvent() {
    print("test fetch");
    globalKeyEvent.currentState?.fetchEvent();
  }

  Future<int> getRole() async {
    user = await UserPreference.getUser();
    return await UserPreference.getUserRole();
  }
}
