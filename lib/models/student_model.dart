/// Model representing a Student entity.
class StudentModel {
  final String id;
  final String rollNumber;
  final String name;
  final String email;
  final String department;
  final String sectionId;
  final String year;
  final String semester;
  final double attendancePercentage;
  final String? phone;

  const StudentModel({
    required this.id,
    required this.rollNumber,
    required this.name,
    required this.email,
    required this.department,
    this.sectionId = 'CS-3A',
    required this.year,
    required this.semester,
    this.attendancePercentage = 0.0,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rollNumber': rollNumber,
      'name': name,
      'email': email,
      'department': department,
      'sectionId': sectionId,
      'year': year,
      'semester': semester,
      'attendancePercentage': attendancePercentage,
      'phone': phone,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      rollNumber: map['rollNumber'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      department: map['department'] ?? '',
      sectionId: map['sectionId'] ?? 'CS-3A',
      year: map['year'] ?? '',
      semester: map['semester'] ?? '',
      attendancePercentage: (map['attendancePercentage'] ?? 0.0).toDouble(),
      phone: map['phone'],
    );
  }

  StudentModel copyWith({
    String? id,
    String? rollNumber,
    String? name,
    String? email,
    String? department,
    String? sectionId,
    String? year,
    String? semester,
    double? attendancePercentage,
    String? phone,
  }) {
    return StudentModel(
      id: id ?? this.id,
      rollNumber: rollNumber ?? this.rollNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      sectionId: sectionId ?? this.sectionId,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      phone: phone ?? this.phone,
    );
  }
}
