class Attendance{
  final int id;
  final int student_id;
  final int event_id;
  final String? attendance_status;
  final DateTime? attendance_date;
  final String event_name;

  Attendance({required this.id, required this.student_id, required this.event_id,  this.attendance_status,  this.attendance_date, required this.event_name});

  factory Attendance.fromJson(Map<String, dynamic> json){
    return Attendance(
      id: json['id'],
      student_id: json['student_id'],
      event_id: json['event_id'],
      attendance_status: json['attendance_status'] ?? "",
      attendance_date: json['attendance_date'] != null ? DateTime.parse(json['attendance_date']) : null ,
      event_name: json['event_name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': student_id,
    'event_id': event_id,
    'attendance_status': attendance_status,
    'attendance_date': attendance_date,
    'event_name': event_name,
  };
}