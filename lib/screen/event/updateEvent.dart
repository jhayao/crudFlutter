import 'dart:convert';

import 'package:crud/model/Event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../api/api.dart';
import '../../model/Student.dart';

// ignore: camel_case_types
class UpdateEvent extends StatefulWidget {
  final Event event;
  final Function() notifyParent;

  const UpdateEvent(
      {super.key, required this.event, required this.notifyParent});

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

// ignore: camel_case_types
class _UpdateEventState extends State<UpdateEvent> {
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
    eventDateController.text = DateFormat('MMMM dd, yyyy - h:mm a').format(widget.event.event_date).toString();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Update Event"),
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
                  //   "",
                  //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: height * 0.05),
                  TextFormField(
                    controller: eventNameController,
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
                    controller: eventDescriptionController,
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
                    controller: eventVenueController,
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
                              position: MotionToastPosition.top,
                              title: const Text("Success"),
                              description: Text("${status['message']}"),
                            ).show(context);
                            widget.notifyParent();
                          } else {
                            MotionToast.error(
                              position: MotionToastPosition.top,
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
    // print(eventDateController.text);
    DateFormat format = DateFormat("MMMM dd, yyyy - h:mm a");
    DateTime dateTime = format.parse(eventDateController.text);

    final response = await CallApi().postData({
      "id": "${widget.event.id}",
      "event_name": eventNameController.text,
      "event_description": eventDescriptionController.text,
      "event_location": eventVenueController.text,
      "event_date": dateTime.toString(),
    }, 'event/update');
    final body = json.decode(response.body);
    return body;
  }
}
