import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/style.dart';
import '../../history/history.dart';

class HitoryView extends StatelessWidget {
  const HitoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'History',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            // prompt settings
            TextButton(
              onPressed: () {
                Get.bottomSheet(const HistoryScreen(),
                    isScrollControlled: true);
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'See all',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 120.sp,
          child: ListView.separated(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (_, __) => SizedBox(width: 16.sp),
            itemBuilder: (_, __) {
              return Container(
                width: 140.sp,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: borderRadius,
                  // image: const DecorationImage(
                  //   image: CachedNetworkImageProvider(''),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
