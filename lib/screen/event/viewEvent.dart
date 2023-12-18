import 'dart:convert';

import 'package:crud/model/Attendance.dart';
import 'package:crud/model/Event.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../api/api.dart';
import '../../model/Student.dart';

// ignore: camel_case_types
class ViewEvent extends StatefulWidget {
  final Event event;
  final Attendance? attendance;
  const ViewEvent({super.key, required this.event, this.attendance});

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

// ignore: camel_case_types
class _ViewEventState extends State<ViewEvent> {
  final formKey = GlobalKey<FormState>();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventNameController.text = widget.event.event_name;
    eventDescriptionController.text = widget.event.event_description;
    eventVenueController.text = widget.event.event_venue;
    eventDateController.text = widget.event.event_date.toString();

  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          // title: const Text("View Student"),
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
                    "View Event",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: eventNameController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Event name",
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
                    controller: eventDescriptionController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: "Event Description",
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
                    enabled: false,
                    controller: eventVenueController,
                    decoration: const InputDecoration(
                      labelText: "Event Venue",
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
                    enabled: false,
                    controller: eventDateController,
                    decoration: const InputDecoration(
                      labelText: "Event Date",
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
                  if(widget.attendance != null)
                    TextFormField(
                      enabled: false,
                      initialValue:  widget.attendance != null && widget.attendance!.attendance_status!.isNotEmpty
                          ? widget.attendance!.attendance_status.toString()
                          : "Not yet checkin",
                      decoration: const InputDecoration(
                        labelText: "Check In",
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
                  SizedBox(height: height * 0.05),
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       if (formKey.currentState!.validate()) {
                  //         // ScaffoldMessenger.of(context).showSnackBar(
                  //         //   const SnackBar(content: Text('Processing Data')),
                  //         // );
                  //         final status = await createStudent();
                  //         if (!context.mounted) return;
                  //         if (status['success'] == true) {
                  //           MotionToast.success(
                  //             position: MotionToastPosition.top,
                  //             title: const Text("Success"),
                  //             description: Text("${status['message']}"),
                  //           ).show(context);
                  //         } else {
                  //           MotionToast.error(
                  //             position: MotionToastPosition.top,
                  //             title: const Text("Error"),
                  //             description: Text("${status['message']}"),
                  //           ).show(context);
                  //         }
                  //         print(status['message']);
                  //       }
                  //     },
                  //     child: const Text(
                  //       "Submit",
                  //       style: TextStyle(fontSize: 20),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )));
  }

  Future<Map<String, dynamic>> createStudent() async {
    final response = await CallApi().postData({
      "student_name": eventNameController.text,
      "student_email": eventDescriptionController.text,
      "student_address": eventVenueController.text,
      "student_phone": eventDateController.text,
    }, 'student-create');
    final body = json.decode(response.body);
    return body;
  }
}
