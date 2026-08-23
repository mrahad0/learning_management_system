import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class CustomSuccessDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final VoidCallback? onDismiss;

  const CustomSuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.check,
    this.iconColor,
    this.iconBackgroundColor,
    this.onDismiss,
  });

  /// Shows the dialog with the given context
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    IconData? icon = Icons.check,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool barrierDismissible = false,
    Duration? autoDismissDuration,
    VoidCallback? onDismiss,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return CustomSuccessDialog(
          title: title,
          subtitle: subtitle,
          icon: icon,
          iconColor: iconColor,
          iconBackgroundColor: iconBackgroundColor,
          onDismiss: onDismiss,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 374.66.w,
        constraints: BoxConstraints(
          minHeight: 230.24.h,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(14.r),
          border: Border(
            top: BorderSide(
              color: const Color(0xFFE5E7EB),
              width: 1.15,
            ),
          ),
          boxShadow: [
            // First shadow: X=0, Y=1, Blur=2, Spread=-1, #000000 10%
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.10),
              offset: const Offset(0, 1),
              blurRadius: 2,
              spreadRadius: -1,
            ),
            // Second shadow: X=0, Y=1, Blur=3, Spread=0, #000000 10%
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.10),
              offset: const Offset(0, 1),
              blurRadius: 3,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: iconBackgroundColor ??
                      AppColors.primaryColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.check,
                  size: 36.sp,
                  color: iconColor ?? AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}