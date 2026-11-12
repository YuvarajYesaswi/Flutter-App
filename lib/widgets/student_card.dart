import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/student_model.dart';

/// Reusable mobile card displaying student details, roll number, department, and attendance badge.
class StudentCard extends StatelessWidget {
  final StudentModel student;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StudentCard({
    super.key,
    required this.student,
    this.onTap,
    this.trailing,
  });

  String get _initials {
    final parts = student.name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'ST';
  }

  Color get _badgeColor {
    return student.attendancePercentage >= 75.0 ? AppColors.success : AppColors.danger;
  }

  Color get _badgeBgColor {
    return student.attendancePercentage >= 75.0 ? AppColors.successLight : AppColors.dangerLight;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Row(
            children: [
              // Initials Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.infoLight,
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.p16),
              // Student Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.p4),
                    Text(
                      'Roll: ${student.rollNumber} • ${student.department}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.p8),
              // Attendance Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p4,
                ),
                decoration: BoxDecoration(
                  color: _badgeBgColor,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Text(
                  '${student.attendancePercentage.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _badgeColor,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSizes.p8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
