import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/attendance_model.dart';
import 'period_chip.dart';

/// Reusable mobile card displaying student details, 7 period chips, and attendance percentage ratio.
class AttendanceCard extends StatelessWidget {
  final AttendanceModel attendance;
  final Function(int period, AttendanceStatus newStatus)? onPeriodToggled;

  const AttendanceCard({
    super.key,
    required this.attendance,
    this.onPeriodToggled,
  });

  AttendanceStatus _getNextStatus(AttendanceStatus current) {
    switch (current) {
      case AttendanceStatus.present:
        return AttendanceStatus.absent;
      case AttendanceStatus.absent:
        return AttendanceStatus.unmarked;
      case AttendanceStatus.unmarked:
      case AttendanceStatus.late:
        return AttendanceStatus.present;
    }
  }

  @override
  Widget build(BuildContext context) {
    final percentage = attendance.percentage;
    final isGoodAttendance = percentage >= 75.0;

    return Card(
      color: AppColors.cardBackground,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Avatar, Student Name, Roll Number, and Attendance Badge (6/7 • 86%)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.infoLight,
                  child: Text(
                    attendance.studentName.isNotEmpty
                        ? attendance.studentName[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Roll: ${attendance.rollNumber}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.p8),

                // Attendance Ratio Badge (e.g. 6 / 7 • 86%)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.p10,
                    vertical: AppSizes.p6,
                  ),
                  decoration: BoxDecoration(
                    color: isGoodAttendance ? AppColors.successLight : AppColors.dangerLight,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Column(
                    children: [
                      Text(
                        attendance.ratioString,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isGoodAttendance ? AppColors.success : AppColors.danger,
                        ),
                      ),
                      Text(
                        attendance.percentageString,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isGoodAttendance ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p12),

            // Period Attendance Heading
            const Text(
              'Period Attendance',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSizes.p8),

            // Period Chips Wrap (P1 to P7)
            Wrap(
              spacing: AppSizes.p6,
              runSpacing: AppSizes.p6,
              children: List.generate(AttendanceModel.totalPeriodsCount, (index) {
                final periodNum = index + 1;
                final status =
                    attendance.periodStatuses[periodNum] ?? AttendanceStatus.present;

                return PeriodChip(
                  periodNumber: periodNum,
                  status: status,
                  onTap: () {
                    final next = _getNextStatus(status);
                    onPeriodToggled?.call(periodNum, next);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
