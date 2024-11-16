import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/images.dart';

class CustomNetworkImage extends StatefulWidget {
  final String? url;
  final BoxFit fit;
  final Color? color;
  final bool errorLoading;
  const CustomNetworkImage(
      {required this.url,
      this.fit = BoxFit.cover,
      this.color,
      this.errorLoading = false,
      super.key});

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${widget.url}",
      fit: BoxFit.cover,
      colorBlendMode: widget.color == null ? null : BlendMode.darken,
      color: widget.color,
      placeholder: (c, s) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            color: Colors.grey[300],
          ),
        );
      },
      errorWidget: (c, s, o) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Center(
            child: widget.errorLoading
                ? Lottie.asset(
                    Images.animation_1,
                    fit: BoxFit.cover,
                  )
                : Icon(Iconsax.image, size: 50.sp),
          ),
        );
      },
    );
  }
}
