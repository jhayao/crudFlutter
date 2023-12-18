import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../api/api.dart';

// ignore: camel_case_types
class createEvent extends StatefulWidget {
  final Function notifyParent;
  const createEvent({super.key, required this.notifyParent});

  @override
  State<createEvent> createState() => _createEventState();
}

// ignore: camel_case_types
class _createEventState extends State<createEvent> {
  final formKey = GlobalKey<FormState>();
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Create Event"),
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
                  //   "Create Student",
                  //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: eventNameController,
                    decoration: const InputDecoration(
                      labelText: "Event Name",
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
                    controller: eventDescriptionController,
                    decoration: const InputDecoration(
                      labelText: "Event Description",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: eventVenueController,
                    decoration: const InputDecoration(
                      labelText: "Event Venue",
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
                    onTap: () async {
                      DateTime? dateTime = await showOmniDateTimePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1600)
                              .subtract(const Duration(days: 3652)),
                          lastDate: DateTime.now().add(
                            const Duration(days: 3652),
                          ),
                          is24HourMode: false,
                          isShowSeconds: false,
                          minutesInterval: 1,
                          secondsInterval: 1,
                          isForce2Digits: true,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(16)),
                          constraints: const BoxConstraints(
                            maxWidth: 350,
                            maxHeight: 650,
                          ),
                          transitionBuilder: (context, anim1, anim2, child) {
                            return FadeTransition(
                              opacity: anim1.drive(
                                Tween(
                                  begin: 0,
                                  end: 1,
                                ),
                              ),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 200),
                          barrierDismissible: true);
                      if (dateTime != null) {
                        setState(() {
                          eventDateController.text = DateFormat('MMMM dd, yyyy - h:mm a').format(dateTime).toString();
                        });
                      }
                    },
                    controller: eventDateController,
                    decoration: const InputDecoration(
                      labelText: "Event Date",
                      labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter date';
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

  Future<Map<String, dynamic>> createStudent() async {
    DateFormat format = DateFormat("MMMM dd, yyyy - h:mm a");
    DateTime dateTime = format.parse(eventDateController.text);
    final response = await CallApi().postData({
      "event_name": eventNameController.text,
      "event_description": eventDescriptionController.text,
      "event_location": eventVenueController.text,
      "event_date": dateTime.toString(),
    }, 'event/create');
    final body = json.decode(response.body);
    return body;
  }
}
