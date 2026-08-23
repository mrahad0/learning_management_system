import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/style.dart';
import 'custom_loading.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.color,
    this.textStyle,
    this.radius,
    this.elevation,
    this.margin = EdgeInsets.zero,
    required this.onTap,
    required this.text,
    this.loading = false,
    this.width,
    this.height,
    this.icon,
    this.suffixIcon,
    this.iconColor,
    this.iconSize,
    this.side,
  });
  final Function() onTap;
  final BorderSide? side;
  final String text;
  final bool loading;
  final double? height;
  final double? width;
  final Color? color;
  final double? radius;
  final double? elevation;
  final EdgeInsetsGeometry margin;
  final TextStyle? textStyle;
  final dynamic icon;
  final dynamic suffixIcon;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: loading ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 14.r),
          ),
          backgroundColor: color ?? AppColors.primaryColor,
          minimumSize: Size(width ?? Get.width, height ?? 47.98.h),
          side: side,
          elevation: elevation,
        ),
        child: loading
            ? CustomLoading(size: 24.h)
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              if (icon is String)
                SvgPicture.asset(
                  icon,
                  // colorFilter: ColorFilter.mode(
                  //   iconColor ?? Colors.white,
                  //   BlendMode.srcIn,
                  // ),
                  width: iconSize ?? 18.w,
                  height: iconSize ?? 18.w,
                )
              else if (icon is IconData)
                Icon(
                  icon,
                  color: iconColor ?? Colors.white,
                  size: iconSize ?? 18.w,
                ),
              SizedBox(width: 8.w),
            ],
            Text(
              text,
              style:
              textStyle ??
                  AppStyles.h4(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
            ),

            if (suffixIcon != null) ...[
              SizedBox(width: 8.w),
              if (suffixIcon is String)
                SvgPicture.asset(
                  suffixIcon,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: iconSize ?? 18.w,
                  height: iconSize ?? 18.w,
                )
              else if (suffixIcon is IconData)
                Icon(
                  suffixIcon,
                  color: iconColor ?? Colors.white,
                  size: iconSize ?? 18.w,
                ),
            ],
          ],
        ),
      ),
    );
  }
}