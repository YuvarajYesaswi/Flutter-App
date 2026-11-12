enum AttendanceStatus { present, absent, unmarked, late }

/// Model representing a Student's Attendance record for a specific Section & Period.
class AttendanceModel {
  final String id;
  final String studentId;
  final String studentName;
  final String rollNumber;
  final String sectionId;
  final int period;
  final String subject;
  final DateTime date;
  final AttendanceStatus status;
  final Map<int, AttendanceStatus> periodStatuses;

  const AttendanceModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.rollNumber,
    this.sectionId = 'CS-3A',
    this.period = 1,
    this.subject = 'Data Structures',
    required this.date,
    this.status = AttendanceStatus.present,
    this.periodStatuses = const {},
  });

  /// Total periods supported per day
  static const int totalPeriodsCount = 7;

  int get presentPeriodCount =>
      periodStatuses.values.where((s) => s == AttendanceStatus.present).length;

  int get absentPeriodCount =>
      periodStatuses.values.where((s) => s == AttendanceStatus.absent).length;

  int get markedPeriodCount =>
      periodStatuses.values.where((s) => s != AttendanceStatus.unmarked).length;

  double get percentage {
    if (totalPeriodsCount == 0) return 0.0;
    return (presentPeriodCount / totalPeriodsCount) * 100.0;
  }

  String get ratioString => '$presentPeriodCount / $totalPeriodsCount';
  String get percentageString => '${percentage.toStringAsFixed(0)}%';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'rollNumber': rollNumber,
      'sectionId': sectionId,
      'period': period,
      'subject': subject,
      'date': date.toIso8601String(),
      'status': status.name,
      'periodStatuses': periodStatuses.map((k, v) => MapEntry(k.toString(), v.name)),
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    final rawPeriods = map['periodStatuses'] as Map<String, dynamic>? ?? {};
    final Map<int, AttendanceStatus> parsedPeriods = {};

    for (int i = 1; i <= totalPeriodsCount; i++) {
      final val = rawPeriods[i.toString()];
      parsedPeriods[i] = AttendanceStatus.values.firstWhere(
        (e) => e.name == val,
        orElse: () => AttendanceStatus.present,
      );
    }

    final rawStatus = map['status'] as String?;
    final parsedStatus = AttendanceStatus.values.firstWhere(
      (e) => e.name == rawStatus,
      orElse: () => AttendanceStatus.present,
    );

    return AttendanceModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      rollNumber: map['rollNumber'] ?? '',
      sectionId: map['sectionId'] ?? 'CS-3A',
      period: map['period'] ?? 1,
      subject: map['subject'] ?? 'Data Structures',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      status: parsedStatus,
      periodStatuses: parsedPeriods,
    );
  }

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? rollNumber,
    String? sectionId,
    int? period,
    String? subject,
    DateTime? date,
    AttendanceStatus? status,
    Map<int, AttendanceStatus>? periodStatuses,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      sectionId: sectionId ?? this.sectionId,
      period: period ?? this.period,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      status: status ?? this.status,
      periodStatuses: periodStatuses ?? Map.from(this.periodStatuses),
    );
  }
}
