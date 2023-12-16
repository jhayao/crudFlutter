import 'dart:convert';

import 'package:crud/api/api.dart';
import 'package:flutter/material.dart';

import '../include/card.dart';
import '../model/Student.dart';
import 'createStudent.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudent();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student"),
      ),
      body: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context,index){
            final student = students[index];
            final email = student.student_email;
            return  CardExample(student: student,notifyParent: fetchStudent);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>  createStudent(notifyParent: fetchStudent,)));
        },

        child: const Icon(Icons.add),
      ),
    );


  }


  void fetchStudent() async {
    // print("Student Fetch Started");
    // const url = "http://127.0.0.1:8000/api/students";
    // final uri = Uri.parse(url);
    // final response = await http.get(uri);
    // final body = response.body;
    // final json = jsonDecode(body);
    // final result = json['data'];
    // final transformed = result.map<Student>((e) => Student.fromJson(e)).toList();
    // setState(() {
    //     students = transformed;
    // });
    CallApi().getData('students').then((response) {
      setState(() {
        Iterable list = json.decode(response.body)['data'];
        students = list.map((model) => Student.fromJson(model)).toList();
      });
    });
  }
}
