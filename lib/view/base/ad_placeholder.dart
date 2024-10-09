import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';

class NativeAdPlaceholder extends StatelessWidget {
  const NativeAdPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding,
      alignment: Alignment.center,
      height: 170,
      width: double.infinity,
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade500,
        child: Row(
          children: [
            Container(
              height: 80,
              width: 80,
              color: primaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 25,
                  color: primaryColor,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 20,
                  width: 30,
                  color: primaryColor,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 25,
                  color: primaryColor,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class BannerAdPlaceholder extends StatelessWidget {
  const BannerAdPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding,
      alignment: Alignment.center,
      color: Theme.of(context).cardColor,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade500,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              color: primaryColor,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  color: primaryColor,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 15,
                  width: 20,
                  color: primaryColor,
                ),
                const SizedBox(height: 5),
                Container(
                  height: 15,
                  color: primaryColor,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
