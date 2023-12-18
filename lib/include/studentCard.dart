import 'dart:convert';

import 'package:crud/screen/student/updateStudent.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:motion_toast/motion_toast.dart';
import '../api/api.dart';
import '../model/Student.dart';
import '../screen/student/viewStudent.dart';

class CardExample extends StatelessWidget {
  final Student student;
  final Function() notifyParent;

  const CardExample(
      {super.key, required this.student, required this.notifyParent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(student.student_name),
              subtitle: Text(student.student_address),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewStudent(
                          student: student,
                        )));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Edit'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdateStudent(
                              student: student,
                              notifyParent: notifyParent,
                            )));
                  },
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () {
                    Dialogs.bottomMaterialDialog(
                        msg: 'Are you sure? you can\'t undo this action',
                        title: 'Delete',
                        context: context,
                        actions: [
                          IconsOutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop(['Test', 'List']);
                            },
                            text: 'Cancel',
                            iconData: Icons.cancel_outlined,
                            textStyle: const TextStyle(color: Colors.grey),
                            iconColor: Colors.grey,
                          ),
                          IconsButton(
                            onPressed: () async {
                              final status = await deleteStudent(student);
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                              notifyParent();
                              if (status['success'] == true) {
                                MotionToast.success(
                                  position: MotionToastPosition.top,
                                  title: const Text("Success"),
                                  description: Text("${status['message']}"),
                                ).show(context);
                              } else {
                                MotionToast.error(
                                  position: MotionToastPosition.top,
                                  title: const Text("Error"),
                                  description: Text("${status['message']}"),
                                ).show(context);
                              }
                            },
                            text: 'Delete',
                            iconData: Icons.delete,
                            color: Colors.red,
                            textStyle: const TextStyle(color: Colors.white),
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
  }

  Future<Map<String, dynamic>> deleteStudent(Student student) async {
    final response =
        await CallApi().postData({"id": "${student.id}"}, 'student-delete');
    final body = json.decode(response.body);
    print(body);
    return body;
  }
}
