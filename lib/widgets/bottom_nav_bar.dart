import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import '../core/constants/app_strings.dart';

/// Reusable mobile bottom navigation bar widget.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined, size: AppSizes.iconMedium),
            activeIcon: Icon(Icons.dashboard, size: AppSizes.iconMedium),
            label: AppStrings.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg_outlined, size: AppSizes.iconMedium),
            activeIcon: Icon(Icons.how_to_reg, size: AppSizes.iconMedium),
            label: AppStrings.navAttendance,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: AppSizes.iconMedium),
            activeIcon: Icon(Icons.people, size: AppSizes.iconMedium),
            label: AppStrings.navStudents,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined, size: AppSizes.iconMedium),
            activeIcon: Icon(Icons.bar_chart, size: AppSizes.iconMedium),
            label: AppStrings.navReports,
          ),
        ],
      ),
    );
  }
}
