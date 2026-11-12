import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_mock_data.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/date_utils.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/class_schedule_card.dart';
import '../../widgets/statistic_card.dart';
import '../attendance/attendance_screen.dart';
import '../reports/reports_screen.dart';
import '../students/students_screen.dart';

/// Main Dashboard Screen and Bottom Navigation shell for Attendance Management System.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;
  DateTime _selectedDate = DateTime.now();
  String _selectedSection = 'CS-3A';
  int _selectedPeriod = 1;

  void _openDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _navigateToAttendance(String section, int period) {
    setState(() {
      _selectedSection = section;
      _selectedPeriod = period;
      _currentNavIndex = 1; // Switch to Attendance tab
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeTab(context),
      AttendanceScreen(
        key: ValueKey('att_${_selectedDate.toIso8601String()}_${_selectedSection}_$_selectedPeriod'),
        initialDate: _selectedDate,
        initialSectionId: _selectedSection,
        initialPeriod: _selectedPeriod,
      ),
      const StudentsScreen(),
      const ReportsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentNavIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  /// Home Tab Dashboard View for Teacher
  Widget _buildHomeTab(BuildContext context) {
    final formattedDate = AppDateUtils.formatDate(_selectedDate);

    return Column(
      children: [
        // App Header
        AppHeader(
          title: 'Good Morning, Teacher 👋',
          subtitle: 'Manage today\'s attendance',
          trailing: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.infoLight,
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),

        // Main Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p20,
              vertical: AppSizes.p8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Selector Banner
                Card(
                  color: AppColors.cardBackground,
                  elevation: AppSizes.cardElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    side: const BorderSide(color: AppColors.border, width: 1),
                  ),
                  child: InkWell(
                    onTap: _openDatePicker,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p16,
                        vertical: AppSizes.p14,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: AppSizes.p12),
                          Expanded(
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.p16),

                // Attendance Summary Metric Cards
                Row(
                  children: [
                    Expanded(
                      child: StatisticCard(
                        title: 'PRESENT',
                        value: '${AppMockData.presentToday}',
                        icon: Icons.check_circle_outline_rounded,
                        iconColor: AppColors.success,
                        iconBackgroundColor: AppColors.successLight,
                      ),
                    ),
                    const SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: StatisticCard(
                        title: 'ABSENT',
                        value: '${AppMockData.absentToday}',
                        icon: Icons.highlight_off_rounded,
                        iconColor: AppColors.danger,
                        iconBackgroundColor: AppColors.dangerLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p12),

                // Total Students Metric Card
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p16,
                    vertical: AppSizes.p12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Students Assigned',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '${AppMockData.totalStudents}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.p24),

                // Section Title: Today's Classes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Today\'s Classes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '3 Sections',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.p12),

                // Timetable Class Schedule Cards List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppMockData.todayClasses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSizes.p10),
                  itemBuilder: (context, index) {
                    final schedule = AppMockData.todayClasses[index];
                    return ClassScheduleCard(
                      schedule: schedule,
                      onTap: () => _navigateToAttendance(schedule.section, schedule.period),
                    );
                  },
                ),
                const SizedBox(height: AppSizes.p24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
