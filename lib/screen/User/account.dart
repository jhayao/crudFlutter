import 'dart:convert';

import 'package:crud/model/User.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../api/api.dart';
import '../../include/UserPreference.dart';
import '../../model/Student.dart';
import '../../pages/auth_page.dart';
import 'changepassword.dart';

// ignore: camel_case_types
class AccountPage extends StatefulWidget {
  final User? user;

  const AccountPage({super.key, this.user});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

// ignore: camel_case_types
class _AccountPageState extends State<AccountPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.user!.student_name;
    emailController.text = widget.user!.email;
    addressController.text = widget.user!.student_address ?? '';
    phoneController.text = widget.user!.student_phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("My Account"),
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
                  // const Text(
                  //   "View Student",
                  //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: height * 0.05),

                  TextFormField(
                    controller: nameController,
                    // enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: InputBorder.none,
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
                    // enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: InputBorder.none,
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
                    // enabled: false,
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: "Address",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: InputBorder.none,
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
                    // enabled: false,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: InputBorder.none,
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
                          final status =
                              await createStudent();
                          print(status);
                          if (status['success']) {
                            // UserPreference.setUser(User.fromJson(status['data']));
                            if (!context.mounted) return;
                            print(status);
                            if (status['success'] == true) {
                              print("tur");
                              MotionToast.success(
                                position: MotionToastPosition.top,
                                title: const Text("Success"),
                                description: Text("${status['message']}"),
                              ).show(context);
                            } else {
                              print("false");
                              MotionToast.error(
                                position: MotionToastPosition.top,
                                title: const Text("Error"),
                                description: Text("${status['message']}"),
                              ).show(context);
                            }
                          }
                          print("aw");
                        }
                      },
                      child: const Text(
                        "Update Profile",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChangePassword()));
                      },
                      child: const Text(
                        "Change Password",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        UserPreference.removeToken();
                        UserPreference.removeUser();
                        UserPreference.removeUserRole();
                        UserPreference.removeUserId();

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const AuthPage()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text(
                        "Logout",
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
      "id": "${widget.user!.student_id}",
      "student_name": nameController.text,
      "student_email": emailController.text,
      "student_address": addressController.text,
      "student_phone": phoneController.text,
    }, 'student-update');
    final body = json.decode(response.body);

    return body;
  }
}
