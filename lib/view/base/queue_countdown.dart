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
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5.sp, color: context.theme.scaffoldBackgroundColor),
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
            if (padding) SizedBox(height: spacingDefault),
            Text(
              remainingTime,
              style: headlineLarge(context).copyWith(color: primaryColor),
            ),
            SizedBox(height: spacingSmall),
            Text(
              isRetrying ? "${'retrying'.tr}. ${'almost_there'.tr}!" : 'creating_your_image'.tr,
              style: bodySmall(context).copyWith(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
