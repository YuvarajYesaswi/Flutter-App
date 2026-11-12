import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// Lightweight custom donut chart widget rendering Present vs Absent distribution with legend.
class AttendanceChart extends StatelessWidget {
  final int presentCount;
  final int absentCount;

  const AttendanceChart({
    super.key,
    required this.presentCount,
    required this.absentCount,
  });

  int get totalCount => presentCount + absentCount;

  double get presentPercentage =>
      totalCount > 0 ? (presentCount / totalCount) * 100.0 : 0.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: AppSizes.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p20),
        child: Column(
          children: [
            Row(
              children: [
                // Custom Donut Ring Chart Painter
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(110, 110),
                        painter: _DonutChartPainter(
                          presentRatio: totalCount > 0 ? presentCount / totalCount : 0.0,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${presentPercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            'Ratio',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.p24),

                // Chart Legend Items
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        color: AppColors.success,
                        label: 'Present Records',
                        value: '$presentCount (${presentPercentage.toStringAsFixed(1)}%)',
                      ),
                      const SizedBox(height: AppSizes.p12),
                      _buildLegendItem(
                        color: AppColors.danger,
                        label: 'Absent Records',
                        value: '$absentCount (${(100.0 - presentPercentage).toStringAsFixed(1)}%)',
                      ),
                      const SizedBox(height: AppSizes.p12),
                      _buildLegendItem(
                        color: AppColors.primary,
                        label: 'Total Evaluated',
                        value: '$totalCount Records',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSizes.p8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double presentRatio;

  _DonutChartPainter({required this.presentRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 8;
    const strokeWidth = 14.0;

    // Background track paint
    final bgPaint = Paint()
      ..color = AppColors.danger
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Present arc paint
    final presentPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * presentRatio;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      presentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.presentRatio != presentRatio;
  }
}
