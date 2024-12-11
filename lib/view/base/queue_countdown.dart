import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';

class QueueCountdown extends StatelessWidget {
  final String remainingTime;
  final bool isRetrying;
  final bool padding;
  const QueueCountdown(
      {super.key, required this.remainingTime, required this.isRetrying, this.padding = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Theme.of(context).hoverColor,
        border: Border(
          bottom: BorderSide(width: 0.5.sp, color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: primaryColor,
        highlightColor: secondaryColor,
        period: const Duration(seconds: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (padding) SizedBox(height: 16.sp),
            Text(
              remainingTime,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: primaryColor),
            ),
            SizedBox(height: 8.sp),
            Text(
              isRetrying ? "${'retrying'.tr}. ${'almost_there'.tr}!" : 'creating_your_image'.tr,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
