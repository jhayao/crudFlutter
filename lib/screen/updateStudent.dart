import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../api/api.dart';
import '../model/Student.dart';

// ignore: camel_case_types
class UpdateStudent extends StatefulWidget {
  final Student student;
  final Function() notifyParent;
  const UpdateStudent({super.key, required this.student, required this.notifyParent});

  @override
  State<UpdateStudent> createState() => _UpdateStudentState();
}

// ignore: camel_case_types
class _UpdateStudentState extends State<UpdateStudent> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController imageController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.student.student_name;
    emailController.text = widget.student.student_email;
    addressController.text = widget.student.student_address;
    phoneController.text = widget.student.student_phone;

  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Update Student"),
        ),
        backgroundColor: const Color(0xFFffffff),
        body: Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.04),
                  const Text(
                    "Create Student",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  SizedBox(height: height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Processing Data')),
                          // );
                          final status = await createStudent();
                          if (!context.mounted) return;
                          if (status['success'] == true) {
                            MotionToast.success(
                              position:  MotionToastPosition.top,
                              title: const Text("Success"),
                              description: Text("${status['message']}"),
                            ).show(context);
                            widget.notifyParent();
                          } else {
                            MotionToast.error(
                              position:  MotionToastPosition.top,
                              title: const Text("Error"),
                              description: Text("${status['message']}"),
                            ).show(context);
                          }
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<Map<String, dynamic>> createStudent() async {
    final response = await CallApi().postData({
      "id": "${widget.student.id}",
      "student_name": nameController.text,
      "student_email": emailController.text,
      "student_address": addressController.text,
      "student_phone": phoneController.text,
      "student_image": imageController.text,
    }, 'student-update');
    final body = json.decode(response.body);
    return body;
  }
}
