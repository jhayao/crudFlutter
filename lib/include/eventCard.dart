import 'dart:convert';

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

class EventCard extends StatefulWidget {
  final Event event;
  final Function() notifyParent;

  const EventCard({super.key, required this.event, required this.notifyParent});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late Future<int> userRole;

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
                      title: Text(widget.event.event_name),
                      subtitle: Text(widget.event.event_venue),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ViewEvent(
                                  event: widget.event,
                                )));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: snapshot.data == 0
                              ? const Text('Edit')
                              : const Text('Join'),
                          onPressed: () {
                            if (snapshot.data == 0) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UpdateEvent(
                                      event: widget.event,
                                      notifyParent: widget.notifyParent,
                                    )));
                            }
                            else{
                              joinAttendance(widget.event.id).then((value) {
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
                                        final status =
                                            await deleteEvent(widget.event);
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

  Future<Map<String, dynamic>> deleteEvent(Event event) async {
    final response =
        await CallApi().postData({"id": "${event.id}"}, 'event/delete');
    final body = json.decode(response.body);
    return body;
  }

  Future<int> getRole() async {
    final userRole = await UserPreference.getUserRole();
    return userRole;
  }

  Future<Map<String, dynamic>> joinAttendance(int eventId) async {
    final response = await CallApi().postData({
      "student_id": await UserPreference.getUserId(),
      "event_id": eventId,
    }, 'attendance/create');
    final body = json.decode(response.body);
    return body;
  }

}
