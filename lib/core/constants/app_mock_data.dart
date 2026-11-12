import '../../models/section_model.dart';
import '../../models/student_model.dart';

/// Class schedule item model for today's classes list.
class ClassSchedule {
  final String time;
  final String subject;
  final String room;
  final String section;
  final int period;

  const ClassSchedule({
    required this.time,
    required this.subject,
    required this.room,
    required this.section,
    this.period = 1,
  });
}

/// Centralized local mock data for Teacher Attendance System.
class AppMockData {
  AppMockData._();

  static const int totalStudents = 42;
  static const int presentToday = 35;
  static const int absentToday = 7;
  static const double overallAttendance = 83.3;

  static const List<SectionModel> sections = [
    SectionModel(
      id: 'CS-3A',
      name: 'CS-3A',
      department: 'Computer Science - Section A',
      defaultSubject: 'Data Structures',
      room: 'Room 301',
      time: '08:30 AM',
      studentCount: 42,
    ),
    SectionModel(
      id: 'CS-3B',
      name: 'CS-3B',
      department: 'Computer Science - Section B',
      defaultSubject: 'Database Management',
      room: 'Lab 2',
      time: '10:30 AM',
      studentCount: 38,
    ),
    SectionModel(
      id: 'IT-2A',
      name: 'IT-2A',
      department: 'Information Technology - Section A',
      defaultSubject: 'Computer Networks',
      room: 'Room 204',
      time: '01:30 PM',
      studentCount: 35,
    ),
  ];

  static const List<ClassSchedule> todayClasses = [
    ClassSchedule(
      time: '08:30 AM',
      subject: 'Data Structures',
      room: 'Room 301',
      section: 'CS-3A',
      period: 1,
    ),
    ClassSchedule(
      time: '10:30 AM',
      subject: 'Database Management',
      room: 'Lab 2',
      section: 'CS-3B',
      period: 2,
    ),
    ClassSchedule(
      time: '01:30 PM',
      subject: 'Computer Networks',
      room: 'Room 204',
      section: 'IT-2A',
      period: 3,
    ),
  ];

  static final List<StudentModel> initialStudents = [
    const StudentModel(
      id: 'st_101',
      rollNumber: '23CS001',
      name: 'Rahul Kumar',
      email: 'rahul.k@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 86.0,
    ),
    const StudentModel(
      id: 'st_102',
      rollNumber: '23CS002',
      name: 'Priya Sharma',
      email: 'priya.s@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 91.0,
    ),
    const StudentModel(
      id: 'st_103',
      rollNumber: '23CS003',
      name: 'Yuvaraj',
      email: 'yuvaraj@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 88.0,
    ),
    const StudentModel(
      id: 'st_104',
      rollNumber: '23CS004',
      name: 'Ananya Sharma',
      email: 'ananya.s@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 78.5,
    ),
    const StudentModel(
      id: 'st_105',
      rollNumber: '23CS005',
      name: 'Amit Verma',
      email: 'amit.v@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 95.0,
    ),
    const StudentModel(
      id: 'st_106',
      rollNumber: '23CS006',
      name: 'Sneha Reddy',
      email: 'sneha.r@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 80.0,
    ),
    const StudentModel(
      id: 'st_107',
      rollNumber: '23CS007',
      name: 'Vikas Gupta',
      email: 'vikas.g@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3A',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 72.0,
    ),
    // Section CS-3B Students
    const StudentModel(
      id: 'st_201',
      rollNumber: '23CS051',
      name: 'David Miller',
      email: 'david.m@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3B',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 94.0,
    ),
    const StudentModel(
      id: 'st_202',
      rollNumber: '23CS052',
      name: 'Rohan Joshi',
      email: 'rohan.j@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3B',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 82.0,
    ),
    const StudentModel(
      id: 'st_203',
      rollNumber: '23CS053',
      name: 'Kavya Singh',
      email: 'kavya.s@college.edu',
      department: 'Computer Science',
      sectionId: 'CS-3B',
      year: '3rd Year',
      semester: '6th Sem',
      attendancePercentage: 89.0,
    ),
    // Section IT-2A Students
    const StudentModel(
      id: 'st_301',
      rollNumber: '24IT001',
      name: 'Emily Chen',
      email: 'emily.c@college.edu',
      department: 'Information Technology',
      sectionId: 'IT-2A',
      year: '2nd Year',
      semester: '4th Sem',
      attendancePercentage: 90.0,
    ),
    const StudentModel(
      id: 'st_302',
      rollNumber: '24IT002',
      name: 'Vikram Patel',
      email: 'vikram.p@college.edu',
      department: 'Information Technology',
      sectionId: 'IT-2A',
      year: '2nd Year',
      semester: '4th Sem',
      attendancePercentage: 85.0,
    ),
  ];
}
