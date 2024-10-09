import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      itemCount: 6,
      padding: EdgeInsets.all(8.sp).copyWith(bottom: 100.sp),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      itemBuilder: (context, index) => InkWell(
        // onTap: () => showDialog(
        //   context: context,
        //   builder: (_) => InspirationDialog(inspiration: inspirations[index]),
        // ),
        child: Stack(
          children: [
            // CustomNetworkImage(
            //   url: inspirations[index].image,
            //   color: Colors.black.withOpacity(0.15),
            // ),
            Container(
              width: double.infinity,
              height: 200 + index * 20.0,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.sp),
                // image: const DecorationImage(
                //   image: CachedNetworkImageProvider(
                //     'https://modelslab.com/cdn-cgi/image/quality=75/https://d9jy2smsrdjcq.cloudfront.net/generations/0-f8891424-4ebc-45e2-98e3-7ef463a058b3.png',
                //   ),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            Positioned(
              bottom: 8.sp,
              right: 8.sp,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Text(
                  'try_now'.tr.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
