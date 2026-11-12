import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

/// Reusable polished button widget supporting solid, outlined, loading states, and optional icons.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final effectiveFgColor = textColor ?? (isOutlined ? AppColors.primary : AppColors.textLight);

    Widget childWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveFgColor),
            ),
          ),
          const SizedBox(width: AppSizes.p8),
        ] else if (icon != null) ...[
          Icon(icon, size: AppSizes.iconMedium, color: effectiveFgColor),
          const SizedBox(width: AppSizes.p8),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: effectiveFgColor,
          ),
        ),
      ],
    );

    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: AppSizes.p20,
          vertical: AppSizes.p16,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
      ),
    );

    if (isOutlined) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle.copyWith(
            side: WidgetStateProperty.all(
              BorderSide(color: effectiveBgColor, width: 1.5),
            ),
          ),
          child: childWidget,
        ),
      );
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return effectiveBgColor.withValues(alpha: 0.5);
            }
            return effectiveBgColor;
          }),
          elevation: WidgetStateProperty.all(0),
        ),
        child: childWidget,
      ),
    );
  }
}
