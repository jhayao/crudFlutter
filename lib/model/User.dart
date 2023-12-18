class User {
  final String name;
  final String email;
  final String student_name;
  final int student_id;
  final String? student_phone;
  final String? student_address;

  User(
      {required this.name,
      required this.email,
      required this.student_name,
      required this.student_id,
       this.student_phone,
       this.student_address});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        student_name = json['student_name'],
        student_id = json['student_id'],
        student_phone = json['student_phone'],
        student_address = json['student_address'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'student_name': student_name,
      'student_id': student_id,
      'student_phone': student_phone,
      'student_address': student_address
    };
  }
}
