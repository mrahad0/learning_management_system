import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key, this.color, this.size});
  final double? size;
  final Color? color;

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double spinnerSize = widget.size ?? 60.0;

    return Center(
      child: SizedBox(
        width: spinnerSize,
        height: spinnerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Ring - Dark Green (Subtle Pulse)
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: spinnerSize,
                height: spinnerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color ?? AppColors.primaryColor,
                    width: 3,
                  ),
                ),
              ),
            ),
            // Inner Ring - Light Green (Pulsing)
            ScaleTransition(
              scale: Tween<double>(begin: 0.65, end: 0.75).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
              child: Container(
                width: spinnerSize,
                height: spinnerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFA7F3D0), // Light mint green
                    width: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}