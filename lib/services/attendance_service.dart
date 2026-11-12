import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/attendance_model.dart';
import 'student_service.dart';

/// Abstract service interface for Attendance operations.
abstract class AttendanceService {
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date);
  Future<List<AttendanceModel>> getAttendanceForSectionAndPeriod(
    DateTime date,
    String sectionId,
    int period,
    String subject,
  );
  Future<void> saveAttendanceForDate(DateTime date, List<AttendanceModel> records);
  Future<void> saveAttendanceForSectionAndPeriod(
    DateTime date,
    String sectionId,
    int period,
    String subject,
    List<AttendanceModel> records,
  );
}

/// Cloud Firestore implementation of AttendanceService with batch saving and fallback support.
class FirestoreAttendanceService implements AttendanceService {
  static final FirestoreAttendanceService _instance = FirestoreAttendanceService._internal();
  factory FirestoreAttendanceService() => _instance;

  FirestoreAttendanceService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;
  final StudentService _studentService = FirestoreStudentService();

  final Map<String, List<AttendanceModel>> _fallbackAttendanceStore = {};

  String _formatKey(DateTime date, [String? sectionId, int? period]) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    if (sectionId != null && period != null) {
      return '${dateStr}_${sectionId.toUpperCase()}_P$period';
    }
    return dateStr;
  }

  @override
  Future<List<AttendanceModel>> getAttendanceForSectionAndPeriod(
    DateTime date,
    String sectionId,
    int period,
    String subject,
  ) async {
    final storeKey = _formatKey(date, sectionId, period);

    try {
      final snapshot = await _firestore
          .collection('attendance')
          .where('dateKey', isEqualTo: storeKey)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return AttendanceModel.fromMap({'id': doc.id, ...data});
        }).toList();
      }
    } catch (_) {}

    if (_fallbackAttendanceStore.containsKey(storeKey)) {
      return List.from(_fallbackAttendanceStore[storeKey]!);
    }

    // Auto-populate initial list from section students
    final students = await _studentService.getStudentsBySection(sectionId);
    final defaultRecords = students.map((s) {
      final isAbsentSample = s.rollNumber.endsWith('4') || s.rollNumber.endsWith('7');
      final initialStatus = isAbsentSample ? AttendanceStatus.absent : AttendanceStatus.present;

      return AttendanceModel(
        id: 'att_${s.id}_$storeKey',
        studentId: s.id,
        studentName: s.name,
        rollNumber: s.rollNumber,
        sectionId: sectionId,
        period: period,
        subject: subject,
        date: date,
        status: initialStatus,
      );
    }).toList();

    _fallbackAttendanceStore[storeKey] = defaultRecords;
    return List.from(defaultRecords);
  }

  @override
  Future<void> saveAttendanceForSectionAndPeriod(
    DateTime date,
    String sectionId,
    int period,
    String subject,
    List<AttendanceModel> records,
  ) async {
    final storeKey = _formatKey(date, sectionId, period);
    _fallbackAttendanceStore[storeKey] = List.from(records);

    try {
      final batch = _firestore.batch();
      final uid = _auth.currentUser?.uid ?? 'system';

      for (final record in records) {
        final docRef = _firestore.collection('attendance').doc(record.id);
        batch.set(
          docRef,
          {
            ...record.toMap(),
            'dateKey': storeKey,
            'sectionId': sectionId,
            'period': period,
            'subject': subject,
            'createdBy': uid,
            'createdAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      await batch.commit();
    } catch (_) {}
  }

  @override
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    return getAttendanceForSectionAndPeriod(date, 'CS-3A', 1, 'Data Structures');
  }

  @override
  Future<void> saveAttendanceForDate(DateTime date, List<AttendanceModel> records) async {
    await saveAttendanceForSectionAndPeriod(date, 'CS-3A', 1, 'Data Structures', records);
  }
}

/// Helper export for backwards compatibility
typedef MockAttendanceService = FirestoreAttendanceService;
