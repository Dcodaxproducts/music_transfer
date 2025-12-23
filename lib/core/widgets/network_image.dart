import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class PrimaryNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  const PrimaryNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "$url",
      fit: fit,
      placeholder: (context, url) {
        return _buildShimmer(context);
      },
      errorWidget: (c, s, o) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: Center(child: Icon(Iconsax.image, size: 50.sp)),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Theme.of(
        context,
      ).textTheme.bodyLarge!.color!.withOpacity(0.05),
      child: Container(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
      ),
    );
  }
}
