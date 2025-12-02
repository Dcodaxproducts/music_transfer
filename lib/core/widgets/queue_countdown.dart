import 'package:shimmer/shimmer.dart';
import '../../imports.dart';

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
            if (padding) SizedBox(height: 16.sp),
            Text(
              remainingTime,
              style: context.font28.copyWith(color: primaryColor),
            ),
            SizedBox(height: 8.sp),
            Text(
              isRetrying ? "${'retrying'.tr}. ${'almost_there'.tr}!" : 'creating_your_image'.tr,
              style: context.font12.copyWith(color: primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
