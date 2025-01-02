import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/colors.dart';
import '../../../utils/style.dart';

class NativeAdPlaceholder extends StatelessWidget {
  const NativeAdPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingDefault,
      alignment: Alignment.center,
      height: 170.sp,
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade500,
        child: Row(
          children: [
            Container(height: 80.sp, width: 80.sp, color: primaryColor),
            SizedBox(width: 10.sp),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 25.sp, color: primaryColor),
                SizedBox(height: 5.sp),
                Container(height: 20.sp, width: 30.sp, color: primaryColor),
                SizedBox(height: 5.sp),
                Container(height: 25.sp, color: primaryColor),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class BannerAdPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  const BannerAdPlaceholder({super.key, this.width = double.infinity, this.height = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.sp,
      width: width.sp,
      padding: paddingDefault,
      alignment: Alignment.center,
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade500,
        child: Row(
          children: [
            Container(height: height.sp, width: height.sp, color: primaryColor),
            SizedBox(width: 10.sp),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: (6 + (Platform.isAndroid ? 2 : 0)).sp, color: primaryColor),
                SizedBox(height: (4 + (Platform.isAndroid ? 1 : 0)).sp),
                Container(height: 6.sp, width: 20.sp, color: primaryColor),
                SizedBox(height: (4 + (Platform.isAndroid ? 1 : 0)).sp),
                Container(height: (6 + (Platform.isAndroid ? 2 : 0)).sp, color: primaryColor),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
