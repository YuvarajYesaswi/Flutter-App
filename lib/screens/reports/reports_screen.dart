import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_mock_data.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/date_utils.dart';
import '../../models/attendance_model.dart';
import '../../services/attendance_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/attendance_chart.dart';
import '../../widgets/custom_button.dart';

/// Reports Screen providing attendance analytics, visual distribution charts, subject breakdown, and student filters.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final AttendanceService _attendanceService = MockAttendanceService();

  DateTime _reportDate = DateTime.now();
  String _selectedSection = 'CS-3A';
  int _selectedPeriod = 1;

  List<AttendanceModel> _attendanceRecords = [];
  bool _isLoading = true;

  final Map<String, String> _sectionSubjects = {
    'CS-3A': 'Data Structures',
    'CS-3B': 'Database Management',
    'IT-2A': 'Computer Networks',
  };

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  String get _currentSubject => _sectionSubjects[_selectedSection] ?? 'Subject';

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
    });

    final records = await _attendanceService.getAttendanceForSectionAndPeriod(
      _reportDate,
      _selectedSection,
      _selectedPeriod,
      _currentSubject,
    );

    if (mounted) {
      setState(() {
        _attendanceRecords = records;
        _isLoading = false;
      });
    }
  }

  int get _presentCount =>
      _attendanceRecords.where((r) => r.status == AttendanceStatus.present).length;

  int get _absentCount =>
      _attendanceRecords.where((r) => r.status == AttendanceStatus.absent).length;

  int get _totalCount => _attendanceRecords.length;

  double get _percentage =>
      _totalCount == 0 ? 0.0 : (_presentCount / _totalCount) * 100.0;

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Section $_selectedSection Period $_selectedPeriod report exported successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            const AppHeader(
              title: 'Attendance Reports',
              subtitle: 'Section & Period Analytics',
            ),

            // Main Scrollable Analytics Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p20,
                  vertical: AppSizes.p8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Row: Date, Section, Period
                    Card(
                      color: AppColors.cardBackground,
                      elevation: AppSizes.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        side: const BorderSide(color: AppColors.border, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.p14),
                        child: Column(
                          children: [
                            // Date Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: AppSizes.p8),
                                    Text(
                                      AppDateUtils.formatDate(_reportDate),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _reportDate,
                                      firstDate: DateTime(2025),
                                      lastDate: DateTime(2030),
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        _reportDate = picked;
                                      });
                                      _loadReportData();
                                    }
                                  },
                                  child: const Text(
                                    'Change Date',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 16),

                            // Section & Period Row
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedSection,
                                      isExpanded: true,
                                      items: AppMockData.sections.map((sec) {
                                        return DropdownMenuItem<String>(
                                          value: sec.id,
                                          child: Text(
                                            'Section: ${sec.name}',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedSection = val;
                                          });
                                          _loadReportData();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSizes.p12),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: _selectedPeriod,
                                      isExpanded: true,
                                      items: List.generate(7, (i) => i + 1).map((p) {
                                        return DropdownMenuItem<int>(
                                          value: p,
                                          child: Text(
                                            'Period $p',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            _selectedPeriod = val;
                                          });
                                          _loadReportData();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // 1. Section & Period Attendance Hero Card
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildOverallSummaryCard(
                            percentage: _percentage,
                            present: _presentCount,
                            absent: _absentCount,
                            total: _totalCount,
                            section: _selectedSection,
                            period: _selectedPeriod,
                            subject: _currentSubject,
                          ),
                    const SizedBox(height: AppSizes.p16),

                    // 2. Visual Donut Ring Chart Widget
                    AttendanceChart(
                      presentCount: _presentCount,
                      absentCount: _absentCount,
                    ),
                    const SizedBox(height: AppSizes.p24),

                    // 3. Student Attendance List Breakdown
                    Text(
                      'Student Breakdown ($_selectedSection - Period $_selectedPeriod)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _attendanceRecords.length,
                      separatorBuilder: (ctx, i) => const SizedBox(height: AppSizes.p8),
                      itemBuilder: (ctx, index) {
                        final record = _attendanceRecords[index];
                        final isPresent = record.status == AttendanceStatus.present;

                        return Container(
                          padding: const EdgeInsets.all(AppSizes.p12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: isPresent ? AppColors.successLight : AppColors.dangerLight,
                                child: Text(
                                  (index + 1).toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isPresent ? AppColors.success : AppColors.danger,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.p12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record.studentName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      record.rollNumber,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.p10,
                                  vertical: AppSizes.p4,
                                ),
                                decoration: BoxDecoration(
                                  color: isPresent ? AppColors.successLight : AppColors.dangerLight,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                ),
                                child: Text(
                                  isPresent ? 'PRESENT' : 'ABSENT',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isPresent ? AppColors.success : AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.p20),

                    // Export Summary Action Button
                    CustomButton(
                      text: 'Export Report Summary',
                      icon: Icons.download_rounded,
                      onPressed: _exportReport,
                    ),
                    const SizedBox(height: AppSizes.p24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallSummaryCard({
    required double percentage,
    required int present,
    required int absent,
    required int total,
    required String section,
    required int period,
    required String subject,
  }) {
    return Card(
      color: AppColors.primary,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p20),
        child: Column(
          children: [
            Text(
              'Section $section • Period $period ($subject)',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDBEAFE),
              ),
            ),
            const SizedBox(height: AppSizes.p6),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            const Divider(color: Color(0xFF60A5FA)),
            const SizedBox(height: AppSizes.p12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCol('Present', '$present', AppColors.successLight),
                _buildSummaryCol('Absent', '$absent', const Color(0xFFFCA5A5)),
                _buildSummaryCol('Total', '$total', AppColors.textLight),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCol(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFBFDBFE),
          ),
        ),
      ],
    );
  }
}
