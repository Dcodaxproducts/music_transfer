import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/features/subscription/data/model/subscription_item.dart';
import 'package:matrix_ai/core/utils/style.dart';
import 'package:matrix_ai/features/language/presentation/view/language.dart';
import '../../../../../core/utils/colors.dart';

class SubscriptionPackageWidget extends StatelessWidget {
  final SubscriptionItem item;
  final bool selected;
  final Function() onTap;
  const SubscriptionPackageWidget(
      {required this.item, required this.selected, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.sp),
          child: TextButton(
            onPressed: onTap,
            child: Container(
              padding: paddingMedium,
              decoration: BoxDecoration(
                borderRadius: borderRadiusDefault,
                color: cardColorDark.withOpacity(0.7),
                border: Border.all(color: selected ? primaryColor : dividerColorDark),
              ),
              child: Row(
                children: [
                  LanguageRadioButton(selected: selected),
                  SizedBox(width: spacingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.tr,
                          style: bodyMedium(context).copyWith(color: Colors.white),
                        ),
                        SizedBox(height: spacingExtraSmall),
                        Text(
                          item.subtitle.tr,
                          style: bodySmall(context).copyWith(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacingSmall),
                  Text(
                    item.price,
                    style: bodyMedium(context).copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (item.promotionText.isNotEmpty)
          Positioned(
            top: 0.sp,
            right: spacingExtraLarge,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: spacingSmall, vertical: spacingExtraSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.sp),
                color: selected ? primaryColor : dividerColorDark,
              ),
              child: Text(
                item.promotionText.toUpperCase(),
                style: labelLarge(context).copyWith(color: Colors.white),
              ),
            ),
          )
      ],
    );
  }
}
