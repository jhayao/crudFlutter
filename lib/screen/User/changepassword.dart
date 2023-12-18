import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../api/api.dart';

// ignore: camel_case_types
class ChangePassword extends StatefulWidget {

  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

// ignore: camel_case_types
class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          // title: const Text("Create Student"),
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
                    "Change Password",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    obscureText: true,
                    controller: currentPassword,
                    decoration: const InputDecoration(
                      labelText: "Current Password",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    obscureText: true,
                    controller: newPassword,
                    decoration: const InputDecoration(
                      labelText: "New Password",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    obscureText: true,
                    controller: confirmPassword,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
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
                          final status = await updatePassword();
                          if (!context.mounted) return;
                          if (status['success'] == true) {
                            MotionToast.success(
                              position:  MotionToastPosition.top,
                              title: const Text("Success"),
                              description: Text("${status['message']}"),
                            ).show(context);
                            // widget.notifyParent();
                          } else {
                            MotionToast.error(
                              position:  MotionToastPosition.top,
                              title: const Text("Error"),
                              description: Text("${status['message']}"),
                            ).show(context);
                          }
                          print(status['message']);
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

  Future<Map<String, dynamic>> updatePassword() async {
    final response = await CallApi().postData({
      "old_password": currentPassword.text,
      "password": newPassword.text,
      "confirm_password": confirmPassword.text,
    }, 'user/change-password');
    final body = json.decode(response.body);
    return body;
  }
}
