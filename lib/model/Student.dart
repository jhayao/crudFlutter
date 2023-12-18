class Student {
  final int id;
  final String student_name;
  final String student_email;
  final String student_phone;
  final String student_address;

  Student(
      {required this.id,
      required this.student_name,
      required this.student_email,
      required this.student_phone,
      required this.student_address,});

  Student.fromJson(Map<String, dynamic> json)
      : student_name = json['student_name'],
        student_email = json['student_email'],
        id = json['id'],
        student_phone = json['student_phone'] ?? '',
        student_address = json['student_address'] ?? '';
}
