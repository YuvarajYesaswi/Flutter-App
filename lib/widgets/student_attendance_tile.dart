import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/attendance_model.dart';

/// Touch-friendly mobile student attendance tile with PRESENT / ABSENT toggle.
class StudentAttendanceTile extends StatelessWidget {
  final int index;
  final String studentName;
  final String rollNumber;
  final AttendanceStatus status;
  final ValueChanged<AttendanceStatus> onStatusChanged;

  const StudentAttendanceTile({
    super.key,
    required this.index,
    required this.studentName,
    required this.rollNumber,
    required this.status,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = status == AttendanceStatus.present;

    return Card(
      color: AppColors.cardBackground,
      elevation: AppSizes.cardElevation,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: BorderSide(
          color: isPresent ? AppColors.success.withValues(alpha: 0.3) : AppColors.danger.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Student Roll/Index Badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.infoLight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.p12),

                // Name & Roll Number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rollNumber,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p12),

            // Segmented Touch-friendly Toggle: [ PRESENT ] [ ABSENT ]
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => onStatusChanged(AttendanceStatus.present),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusSmall),
                      bottomLeft: Radius.circular(AppSizes.radiusSmall),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.p10),
                      decoration: BoxDecoration(
                        color: isPresent ? AppColors.success : AppColors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSizes.radiusSmall),
                          bottomLeft: Radius.circular(AppSizes.radiusSmall),
                        ),
                        border: Border.all(
                          color: isPresent ? AppColors.success : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: isPresent ? Colors.white : AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.p6),
                          Text(
                            'PRESENT',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isPresent ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => onStatusChanged(AttendanceStatus.absent),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(AppSizes.radiusSmall),
                      bottomRight: Radius.circular(AppSizes.radiusSmall),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.p10),
                      decoration: BoxDecoration(
                        color: !isPresent ? AppColors.danger : AppColors.surface,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(AppSizes.radiusSmall),
                          bottomRight: Radius.circular(AppSizes.radiusSmall),
                        ),
                        border: Border.all(
                          color: !isPresent ? AppColors.danger : AppColors.border,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel_rounded,
                            size: 18,
                            color: !isPresent ? Colors.white : AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.p6),
                          Text(
                            'ABSENT',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: !isPresent ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
