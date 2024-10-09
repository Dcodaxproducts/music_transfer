import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../../../utils/colors.dart';

class PurchaseItem extends StatelessWidget {
  final IAPItem item;
  final bool selected;
  final Function()? onTap;
  const PurchaseItem(
      {required this.item, required this.selected, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = getText();
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: borderRadius,
          border: Border.all(
            color:
                selected ? Theme.of(context).primaryColor : Colors.transparent,
            width: 1.sp,
          ),
          // boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            // selected container,
            Container(
              width: 18.sp,
              height: 18.sp,
              padding: EdgeInsets.all(3.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? primaryColor : Colors.grey,
                  width: 1.sp,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: selected ? primaryColor : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(width: 16.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.sp),
                  Text(
                    data['subtitle'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.sp),
            Text(
              data['price'],
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> getText() {
    if (item.productId == 'monthly_plan') {
      return {
        'title': '1 Month',
        'subtitle': 'One Week Subscription',
        "price": item.localizedPrice ?? '0.0',
      };
    } else if (item.productId == 'weekly_plan') {
      return {
        'title': '1 Week',
        'subtitle': 'One Month Subscription',
        "price": item.localizedPrice ?? '0.0',
      };
    } else {
      return {
        'title': '1 Year',
        'subtitle': 'One Year Subscription',
        "price": item.localizedPrice ?? '0.0',
      };
    }
  }
}
