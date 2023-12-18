class Event{
  final int id;
  final String event_name;
  final String event_venue;
  final String event_description;
  final DateTime event_date;

  Event({required this.id, required this.event_name, required this.event_description, required this.event_date, required this.event_venue});

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      id: json['id'],
      event_name: json['event_name'],
      event_description: json['event_description'],
      event_venue: json['event_location'],
      event_date: DateTime.parse(json['event_date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_name': event_name,
    'event_description': event_description,
    'event_venue': event_venue,
    'event_date': event_date,
  };
}