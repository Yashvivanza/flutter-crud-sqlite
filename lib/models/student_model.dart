class StudentModel {
  int? id;
  String name;
  String course;
  String email;

  StudentModel({
    this.id,
    required this.name,
    required this.course,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'email': email,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      course: map['course'],
      email: map['email'],
    );
  }
}