import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final Color? textColor;
  final Color? hintColor;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isOutlined;
  final double? borderRadius;
  final BorderSide? borderSide;
  final int? maxLines;
  final Widget? visibilityIcon;
  final Widget? visibilityOffIcon;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscure = '*',
    this.filColor,
    this.labelText,
    this.isPassword = false,
    this.textColor,
    this.hintColor,
    this.prefixText,
    this.prefixStyle,
    this.focusNode,
    this.inputFormatters,
    this.enabled = true,
    this.isOutlined = false,
    this.borderRadius,
    this.borderSide,
    this.maxLines,
    this.visibilityIcon,
    this.visibilityOffIcon,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  late FocusNode _focusNode;
  bool _isFocused = false;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? 8.r;

    return TextFormField(
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscure ?? '*',
      validator: widget.validator,
      focusNode: _focusNode,
      cursorColor: AppColors.primaryColor,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? obscureText : false,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      style: TextStyle(
        color: widget.textColor ?? const Color(0xFF1E293B),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal ?? 16.w,
          vertical: widget.contentPaddingVertical ?? 14.h,
        ),
        fillColor:
        widget.filColor ??
            (widget.isOutlined ? Colors.white : const Color(0xFFF8FAFC)),
        filled: true,
        prefixIcon: widget.prefixIcon != null
            ? ColorFiltered(
          colorFilter: ColorFilter.mode(
            _isFocused ? AppColors.primaryColor : const Color(0xFF94A3B8),
            BlendMode.srcIn,
          ),
          child: widget.prefixIcon,
        )
            : null,
        prefixText: widget.prefixText,
        prefixStyle:
        widget.prefixStyle ??
            TextStyle(
              color: const Color(0xFF94A3B8),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: toggle,
          child: obscureText
              ? (widget.visibilityOffIcon ??
              _suffixIcon(Icons.visibility_off))
              : (widget.visibilityIcon ?? _suffixIcon(Icons.visibility)),
        )
            : widget.suffixIcon,
        prefixIconConstraints: BoxConstraints(minHeight: 24.w, minWidth: 48.w),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor ?? const Color(0xFFCBD5E1),
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: widget.isOutlined
              ? const BorderSide(color: Color(0xFFE5E7EB), width: 1)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: widget.isOutlined
              ? const BorderSide(color: Color(0xFFE5E7EB), width: 1)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),

          borderSide: widget.borderSide ?? BorderSide.none,
        ),
      ),
    );
  }

  Widget _suffixIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Icon(icon, color: const Color(0xFF94A3B8)),
    );
  }
}