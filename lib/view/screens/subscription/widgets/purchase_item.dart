import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/data/model/subscription_item.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/language/language.dart';
import '../../../../utils/colors.dart';

class SubscriptionPackageWidget extends StatelessWidget {
  final SubscriptionItem item;
  final bool selected;
  final Function() onTap;
  const SubscriptionPackageWidget(
      {required this.item,
      required this.selected,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.sp),
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            onPressed: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: cardColorDark.withOpacity(0.7),
                border: Border.all(
                  color: selected ? primaryColor : Colors.grey[800]!,
                ),
              ),
              child: Row(
                children: [
                  LanguageRadioButton(selected: selected),
                  SizedBox(width: 8.sp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.sp),
                        Text(
                          item.subtitle.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.sp),
                  Text(
                    item.price,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (item.promotionText.isNotEmpty)
          Positioned(
            top: 0.sp,
            right: 32.sp,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.sp),
                color: selected ? primaryColor : Colors.grey[800]!,
              ),
              child: Text(item.promotionText.tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white)),
            ),
          )
      ],
    );
  }
}
