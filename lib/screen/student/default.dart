import 'dart:convert';

import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../include/studentCard.dart';
import '../../model/Student.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});


  @override
  State<DefaultPage> createState() => DefaultPageState();
}

class DefaultPageState extends State<DefaultPage> {
  List<Student> students = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStudent();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Default"),
        ),
        body: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final email = student.student_email;
              return CardExample(student: student, notifyParent: fetchStudent);
            }));
  }

  void fetchStudent() async {
    print("start fetching");
    CallApi().getData('students').then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['data'];
        students = list.map((model) => Student.fromJson(model)).toList();
      });
    });
    print("end fetching");
  }
}
