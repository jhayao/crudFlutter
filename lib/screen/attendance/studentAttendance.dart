import 'dart:convert';

import 'package:crud/include/AttendanceCard.dart';
import 'package:crud/include/UserPreference.dart';
import 'package:crud/model/Attendance.dart';
import 'package:crud/model/Event.dart';
import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../include/eventCard.dart';
class StudentAttendance extends StatefulWidget {
  const StudentAttendance({super.key});


  @override
  State<StudentAttendance> createState() => StudentAttendanceState();
}

class StudentAttendanceState extends State<StudentAttendance> {
  List<Attendance> attendances = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAttendance();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: ListView.builder(
            itemCount: attendances.length,
            itemBuilder: (context, index) {
              final attendance = attendances[index];
              // final event_name = attendance.event_name;
              return AttendanceCard(attendance: attendance, notifyParent: fetchAttendance);
            }));
  }

  void fetchAttendance() async {
    print("start event fetching");
    CallApi().getData('attendance/list?student_id=${await UserPreference.getUserId()}',).then((response) {
      final responseString = json.decode(response.body);
      print(responseString);
      if(responseString['data'] != null ){
        setState(() {
          Iterable list = json.decode(response.body)['data'];
          attendances = list.map((model) => Attendance.fromJson(model)).toList();
        });
      }
    });
    print("end event fetching");
  }
}
