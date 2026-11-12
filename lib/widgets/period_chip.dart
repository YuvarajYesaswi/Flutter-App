import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../models/attendance_model.dart';

/// Compact mobile period chip widget (P1 ✓, P7 ✕).
class PeriodChip extends StatelessWidget {
  final int periodNumber;
  final AttendanceStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  const PeriodChip({
    super.key,
    required this.periodNumber,
    required this.status,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bg;
    String symbol;

    if (isSelected) {
      color = AppColors.primary;
      bg = AppColors.infoLight;
      symbol = 'P$periodNumber';
    } else {
      switch (status) {
        case AttendanceStatus.present:
          color = AppColors.success;
          bg = AppColors.successLight;
          symbol = '✓';
          break;
        case AttendanceStatus.absent:
          color = AppColors.danger;
          bg = AppColors.dangerLight;
          symbol = '✕';
          break;
        case AttendanceStatus.unmarked:
        case AttendanceStatus.late:
          color = AppColors.textSecondary;
          bg = AppColors.inputFill;
          symbol = '-';
          break;
      }
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.p10,
          vertical: AppSizes.p6,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: Border.all(
            color: status == AttendanceStatus.unmarked ? AppColors.border : color,
            width: status == AttendanceStatus.unmarked ? 1 : 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'P$periodNumber',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(width: 3),
            Text(
              symbol,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
