import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassBoxCurve extends StatelessWidget {
  final Widget child;
  const GlassBoxCurve({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(40.sp),
      child: Stack(
        children: [
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 7.sp, sigmaY: 7.sp)),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.sp),
              border: Border.all(color: cardColor, width: 1.sp),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cardColor, cardColor.withOpacity(0.2)],
                stops: const [0.0, 1.0],
              ),
              boxShadow: [
                BoxShadow(color: cardColor.withOpacity(0.2), blurRadius: 30, offset: const Offset(2, 2))
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
