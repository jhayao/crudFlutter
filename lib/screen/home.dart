import 'dart:convert';

import 'package:crud/api/api.dart';
import 'package:crud/screen/default.dart';
import 'package:crud/screen/profile.dart';
import 'package:crud/screen/setting.dart';
import 'package:flutter/material.dart';

import '../include/card.dart';
import '../model/Student.dart';
import 'createStudent.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _bottomNavIndex = 0;
  final List<Widget> _children = [
    const DefaultPage(),
    const EventPage(),
    const SettingPage(),
    const ProfilePage(),
  ];

  final iconList = <IconData>[
    Icons.home,
    Icons.calendar_month,
    Icons.settings,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: _children[_bottomNavIndex],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => createStudent(
                      notifyParent: fetchStudent,
                    )));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
  }

  void fetchStudent(){
    print("fetchStudent");
  }
}
