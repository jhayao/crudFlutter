import 'dart:convert';

import 'package:crud/model/Attendance.dart';
import 'package:crud/screen/event/updateEvent.dart';
import 'package:crud/screen/student/updateStudent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:motion_toast/motion_toast.dart';
import '../api/api.dart';
import '../model/Event.dart';
import '../model/Student.dart';
import '../screen/event/viewEvent.dart';
import '../screen/student/viewStudent.dart';
import 'UserPreference.dart';

class AttendanceCard extends StatefulWidget {
  final Attendance attendance;

  // final int? index;
  final Function() notifyParent;

  const AttendanceCard(
      {super.key, required this.attendance, required this.notifyParent});

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  late Future<int> userRole;
  Event? event;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRole = getRole();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: userRole,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(widget.attendance.event_name),
                      subtitle: Text(widget.attendance.event_name),
                      onTap: () async {
                        Event event =
                            await fetchEvent(widget.attendance.event_id);
                        if (!context.mounted) return;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewEvent(
                                event: event, attendance: widget.attendance)));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: snapshot.data == 0
                              ? const Text('Edit')
                              : const Text('Check In'),
                          onPressed: () {
                            if (snapshot.data == 0) {
                              print("edit");
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => UpdateEvent(
                              //       event: widget.attendance,
                              //       notifyParent: widget.notifyParent,
                              //     )));
                            } else {
                              checkInAttendance(widget.attendance.id)
                                  .then((value) {
                                print(value);
                                if (value['success'] == true) {
                                  MotionToast.success(
                                    position: MotionToastPosition.top,
                                    title: const Text("Success"),
                                    description: Text("${value['message']}"),
                                  ).show(context);
                                } else {
                                  MotionToast.error(
                                    position: MotionToastPosition.top,
                                    title: const Text("Error"),
                                    description: Text("${value['message']}"),
                                  ).show(context);
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        if (snapshot.data == 0)
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Dialogs.bottomMaterialDialog(
                                  msg:
                                      'Are you sure? you can\'t undo this action',
                                  title: 'Delete',
                                  context: context,
                                  actions: [
                                    IconsOutlineButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(['Test', 'List']);
                                      },
                                      text: 'Cancel',
                                      iconData: Icons.cancel_outlined,
                                      textStyle:
                                          const TextStyle(color: Colors.grey),
                                      iconColor: Colors.grey,
                                    ),
                                    IconsButton(
                                      onPressed: () async {
                                        final status = await deleteEvent(
                                            widget.attendance);
                                        if (!context.mounted) return;
                                        Navigator.of(context).pop();
                                        widget.notifyParent();
                                        if (status['success'] == true) {
                                          MotionToast.success(
                                            position: MotionToastPosition.top,
                                            title: const Text("Success"),
                                            description:
                                                Text("${status['message']}"),
                                          ).show(context);
                                        } else {
                                          MotionToast.error(
                                            position: MotionToastPosition.top,
                                            title: const Text("Error"),
                                            description:
                                                Text("${status['message']}"),
                                          ).show(context);
                                        }
                                      },
                                      text: 'Delete',
                                      iconData: Icons.delete,
                                      color: Colors.red,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ]);
                              print("delete");
                            },
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("Loading"));
          }
        });
  }

  Future<Map<String, dynamic>> deleteEvent(Attendance attendance) async {
    final response = await CallApi()
        .postData({"id": "${attendance.id}"}, 'attendance/delete');
    final body = json.decode(response.body);
    return body;
  }

  Future<int> getRole() async {
    final userRole = await UserPreference.getUserRole();
    return userRole;
  }

  Future<Map<String, dynamic>> checkInAttendance(int eventId) async {
    final response = await CallApi().postData({
      "student_id": await UserPreference.getUserId(),
      "event_id": eventId,
    }, 'attendance/checkin');
    final body = json.decode(response.body);
    return body;
  }

  Future<Event> fetchEvent(int eventId) async {
    print("start event fetching");
    Event event = await CallApi()
        .getData(
      'event/details?id=$eventId',
    )
        .then((response) {
      final responseString = json.decode(response.body);

      // print(responseString);
      if (responseString['data'] != null) {
        Event? events = Event.fromJson(responseString['data']);
        print(events.toJson());
        return events;
      } else {
        print("Event Not Found");
        return Event(
            id: 0,
            event_name: "Event Not Found",
            event_venue: "Event Not Found",
            event_date: DateTime.now(),
            event_description: "Event Not Found");
      }
    });
    return event;
  }
}
