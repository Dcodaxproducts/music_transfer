import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix_ai/utils/images.dart';
import '../../../../utils/colors.dart';

class ProgressButton extends StatelessWidget {
  final double percentage;
  const ProgressButton({required this.percentage, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(5.sp),
          width: 60.sp,
          height: 60.sp,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: secondaryGradient),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 2.sp),
              Image.asset(Images.play, width: 24.sp, height: 24.sp),
            ],
          ),
        ),
        // circle progress,
        Positioned.fill(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: percentage),
            duration: const Duration(milliseconds: 500),
            builder: (context, double value, child) => CircularProgressIndicator(
              strokeWidth: 4.sp,
              value: value,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }
}
