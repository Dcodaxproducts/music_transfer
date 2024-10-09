import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/style.dart';
import '../../set_theme/set_theme.dart';

class ModelWidget extends StatelessWidget {
  const ModelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.sp),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Set a theme',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Get.bottomSheet(const SetThemeScreen(),
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
          height: 110.sp,
          child: ListView.separated(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => SizedBox(width: 16.sp),
              itemBuilder: (_, __) {
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 100.sp,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: borderRadius,
                          // image: const DecorationImage(
                          //   image: CachedNetworkImageProvider(''),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }
}
