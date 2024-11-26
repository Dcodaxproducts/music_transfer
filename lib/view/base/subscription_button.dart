import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/subscription_controller.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../../utils/colors.dart';

class SubsriptionButton extends StatelessWidget {
  const SubsriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(builder: (con) {
      return Visibility(
        visible: !con.isPro,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: ElevatedButton(
            onPressed: showPremiumSheet,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.sp),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Wrap(
                spacing: 5.sp,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Iconsax.crown_1,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  Text(
                    'go_pro'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
