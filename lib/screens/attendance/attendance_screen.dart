import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_mock_data.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/date_utils.dart';
import '../../models/attendance_model.dart';
import '../../routes/app_routes.dart';
import '../../services/attendance_service.dart';
import '../../widgets/app_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/period_chip.dart';
import '../../widgets/student_attendance_tile.dart';
import 'date_picker_dialog.dart';

/// Mobile-first Teacher Attendance Screen supporting section & period selection, live counts, and fast toggle marking.
class AttendanceScreen extends StatefulWidget {
  final DateTime? initialDate;
  final String? initialSectionId;
  final int? initialPeriod;

  const AttendanceScreen({
    super.key,
    this.initialDate,
    this.initialSectionId,
    this.initialPeriod,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = MockAttendanceService();

  late DateTime _selectedDate;
  late String _selectedSectionId;
  late int _selectedPeriod;

  List<AttendanceModel> _attendanceRecords = [];
  bool _isLoading = true;
  bool _isSaving = false;

  final Map<String, String> _sectionSubjects = {
    'CS-3A': 'Data Structures',
    'CS-3B': 'Database Management',
    'IT-2A': 'Computer Networks',
  };

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _selectedSectionId = widget.initialSectionId ?? 'CS-3A';
    _selectedPeriod = widget.initialPeriod ?? 1;

    _loadAttendance();
  }

  String get _currentSubject =>
      _sectionSubjects[_selectedSectionId] ?? 'Subject';

  Future<void> _loadAttendance() async {
    setState(() {
      _isLoading = true;
    });

    final records = await _attendanceService.getAttendanceForSectionAndPeriod(
      _selectedDate,
      _selectedSectionId,
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

  void _onStatusToggled(int index, AttendanceStatus newStatus) {
    setState(() {
      final oldRecord = _attendanceRecords[index];
      _attendanceRecords[index] = oldRecord.copyWith(status: newStatus);
    });
  }

  int get _presentCount =>
      _attendanceRecords.where((r) => r.status == AttendanceStatus.present).length;

  int get _absentCount =>
      _attendanceRecords.where((r) => r.status == AttendanceStatus.absent).length;

  int get _totalCount => _attendanceRecords.length;

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _loadAttendance();
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _loadAttendance();
  }

  Future<void> _openDatePicker() async {
    final pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => CustomDatePickerDialog(initialDate: _selectedDate),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _loadAttendance();
    }
  }

  Future<void> _saveAttendance() async {
    setState(() {
      _isSaving = true;
    });

    await _attendanceService.saveAttendanceForSectionAndPeriod(
      _selectedDate,
      _selectedSectionId,
      _selectedPeriod,
      _currentSubject,
      _attendanceRecords,
    );

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance saved successfully.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _navigateToAddStudent() async {
    await Navigator.of(context).pushNamed(
      AppRoutes.addStudent,
      arguments: _selectedSectionId,
    );
    _loadAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            AppHeader(
              title: 'Mark Attendance',
              subtitle: AppDateUtils.formatDate(_selectedDate),
            ),

            // Main Controls Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Navigation Row
                    Card(
                      color: AppColors.cardBackground,
                      elevation: AppSizes.cardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        side: const BorderSide(color: AppColors.border, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.p8,
                          vertical: AppSizes.p4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
                              onPressed: _previousDay,
                              tooltip: 'Previous Day',
                            ),
                            InkWell(
                              onTap: _openDatePicker,
                              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.p12,
                                  vertical: AppSizes.p8,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: AppSizes.iconMedium,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: AppSizes.p8),
                                    Text(
                                      AppDateUtils.formatDate(_selectedDate),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                              onPressed: _nextDay,
                              tooltip: 'Next Day',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.p12),

                    // Section & Subject Selection Row
                    Row(
                      children: [
                        // Section Dropdown Picker
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedSectionId,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                                isExpanded: true,
                                items: AppMockData.sections.map((sec) {
                                  return DropdownMenuItem<String>(
                                    value: sec.id,
                                    child: Text(
                                      'Section: ${sec.name}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedSectionId = val;
                                    });
                                    _loadAttendance();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.p10),

                        // Subject Badge
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.p12,
                              vertical: AppSizes.p12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.infoLight,
                              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _currentSubject,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.p12),

                    // Period Selection Chips Row (Period 1 to 7)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(7, (index) {
                          final pNum = index + 1;
                          final isSelected = pNum == _selectedPeriod;

                          return Padding(
                            padding: const EdgeInsets.only(right: AppSizes.p8),
                            child: PeriodChip(
                              periodNumber: pNum,
                              isSelected: isSelected,
                              status: isSelected ? AttendanceStatus.present : AttendanceStatus.unmarked,
                              onTap: () {
                                setState(() {
                                  _selectedPeriod = pNum;
                                });
                                _loadAttendance();
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Live Attendance Summary Banner (Present: X | Absent: Y | Total: Z)
                    Container(
                      padding: const EdgeInsets.all(AppSizes.p14),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildLiveCounter('PRESENT', '$_presentCount', AppColors.successLight),
                          Container(height: 28, width: 1, color: Colors.white24),
                          _buildLiveCounter('ABSENT', '$_absentCount', AppColors.dangerLight),
                          Container(height: 28, width: 1, color: Colors.white24),
                          _buildLiveCounter('TOTAL', '$_totalCount', Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.p16),

                    // Section Title & "+ Add Student" Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Student List (${_attendanceRecords.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _navigateToAddStudent,
                          icon: const Icon(Icons.person_add_rounded, size: 18, color: AppColors.primary),
                          label: const Text(
                            '+ Add Student',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.p8),

                    // Student Attendance Cards List
                    _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(AppSizes.p32),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : _attendanceRecords.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppSizes.p32),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                  border: Border.all(color: AppColors.border, width: 1),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.people_outline_rounded,
                                      size: 44,
                                      color: AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: AppSizes.p12),
                                    const Text(
                                      'No students found in this section.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSizes.p12),
                                    ElevatedButton.icon(
                                      onPressed: _navigateToAddStudent,
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Add Student to Section'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _attendanceRecords.length,
                                separatorBuilder: (ctx, i) => const SizedBox(height: AppSizes.p10),
                                itemBuilder: (ctx, index) {
                                  final record = _attendanceRecords[index];
                                  return StudentAttendanceTile(
                                    index: index,
                                    studentName: record.studentName,
                                    rollNumber: record.rollNumber,
                                    status: record.status,
                                    onStatusChanged: (newStatus) => _onStatusToggled(index, newStatus),
                                  );
                                },
                              ),
                    const SizedBox(height: AppSizes.p20),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Save Attendance Action Bar
            Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: CustomButton(
                text: 'Save Attendance',
                icon: Icons.save_outlined,
                isLoading: _isSaving,
                onPressed: _saveAttendance,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveCounter(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
