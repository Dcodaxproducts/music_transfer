import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../../utils/colors.dart';

class SubsriptionButton extends StatelessWidget {
  const SubsriptionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          Get.bottomSheet(const SubscriptionScreen(), isScrollControlled: true),
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero, backgroundColor: primaryColor),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
        child: Wrap(
          spacing: 5.sp,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(
              Iconsax.crown_1,
              color: Colors.white,
              size: 20,
            ),
            Text(
              'go_pro'.tr,
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
