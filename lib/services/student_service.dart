import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_mock_data.dart';
import '../models/student_model.dart';

/// Abstract service interface for Student CRUD operations.
abstract class StudentService {
  Future<List<StudentModel>> getStudents();
  Future<List<StudentModel>> getStudentsBySection(String sectionId);
  Future<StudentModel?> getStudentById(String id);
  Future<void> addStudent(StudentModel student);
  Future<void> deleteStudent(String id);
  Future<List<StudentModel>> searchStudents(String query, {String? sectionId});
}

/// Cloud Firestore implementation of StudentService with fallback support.
class FirestoreStudentService implements StudentService {
  static final FirestoreStudentService _instance = FirestoreStudentService._internal();
  factory FirestoreStudentService() => _instance;

  FirestoreStudentService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  // In-memory fallback cache for dev / offline execution
  final List<StudentModel> _fallbackStudents = List.from(AppMockData.initialStudents);

  @override
  Future<List<StudentModel>> getStudents() async {
    try {
      final snapshot = await _firestore.collection('students').orderBy('rollNumber').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return StudentModel.fromMap({'id': doc.id, ...data});
        }).toList();
      }
    } catch (_) {}
    return List.from(_fallbackStudents);
  }

  @override
  Future<List<StudentModel>> getStudentsBySection(String sectionId) async {
    final allStudents = await getStudents();
    if (sectionId.isEmpty || sectionId.toLowerCase() == 'all') {
      return allStudents;
    }
    return allStudents.where((s) => s.sectionId.toUpperCase() == sectionId.toUpperCase()).toList();
  }

  @override
  Future<StudentModel?> getStudentById(String id) async {
    try {
      final doc = await _firestore.collection('students').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return StudentModel.fromMap({'id': doc.id, ...doc.data()!});
      }
    } catch (_) {}
    try {
      return _fallbackStudents.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addStudent(StudentModel student) async {
    try {
      final uid = _auth.currentUser?.uid ?? 'system';
      final docRef = _firestore.collection('students').doc(student.id);
      await docRef.set({
        ...student.toMap(),
        'createdBy': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}

    _fallbackStudents.insert(0, student);
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      await _firestore.collection('students').doc(id).delete();
    } catch (_) {}

    _fallbackStudents.removeWhere((s) => s.id == id);
  }

  @override
  Future<List<StudentModel>> searchStudents(String query, {String? sectionId}) async {
    List<StudentModel> list;
    if (sectionId != null && sectionId.isNotEmpty && sectionId.toLowerCase() != 'all') {
      list = await getStudentsBySection(sectionId);
    } else {
      list = await getStudents();
    }

    if (query.trim().isEmpty) return list;

    final q = query.trim().toLowerCase();
    return list.where((student) {
      final nameMatch = student.name.toLowerCase().contains(q);
      final rollMatch = student.rollNumber.toLowerCase().contains(q);
      final deptMatch = student.department.toLowerCase().contains(q);
      return nameMatch || rollMatch || deptMatch;
    }).toList();
  }
}

/// Helper export for backwards compatibility
typedef MockStudentService = FirestoreStudentService;
