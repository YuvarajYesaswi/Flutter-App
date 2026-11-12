/// Model representing a Section / Class taught by a Teacher.
class SectionModel {
  final String id;
  final String name;
  final String department;
  final String defaultSubject;
  final String room;
  final String time;
  final int studentCount;

  const SectionModel({
    required this.id,
    required this.name,
    required this.department,
    required this.defaultSubject,
    required this.room,
    required this.time,
    this.studentCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'department': department,
      'defaultSubject': defaultSubject,
      'room': room,
      'time': time,
      'studentCount': studentCount,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      department: map['department'] ?? '',
      defaultSubject: map['defaultSubject'] ?? '',
      room: map['room'] ?? '',
      time: map['time'] ?? '',
      studentCount: map['studentCount'] ?? 0,
    );
  }
}
