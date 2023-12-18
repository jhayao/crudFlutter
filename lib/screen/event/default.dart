import 'dart:convert';

import 'package:crud/model/Event.dart';
import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../include/eventCard.dart';
import 'default.dart';
class EventDefaultPage extends StatefulWidget {
  const EventDefaultPage({super.key});


  @override
  State<EventDefaultPage> createState() => EventDefaultPageState();
}

class EventDefaultPageState extends State<EventDefaultPage> {
  List<Event> events = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEvent();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Default"),
        ),
        body: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final event_name = event.event_name;
              return EventCard(event: event, notifyParent: fetchEvent);
            }));
  }

  void fetchEvent() async {
    print("start event fetching");
    CallApi().getData('event\\list',).then((response) {
      final responseString = json.decode(response.body);
      // print(responseString);
      if(responseString['data'] != null ){
        setState(() {
          Iterable list = json.decode(response.body)['data'];
          events = list.map((model) => Event.fromJson(model)).toList();
        });
      }
    });
    print("end event fetching");
  }
}
