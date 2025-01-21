import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/images.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CustomNetworkImage extends StatefulWidget {
  final String? url;
  final BoxFit fit;
  final Color? color;
  final bool errorLoading;

  const CustomNetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.color,
    this.errorLoading = false,
    super.key,
  });

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  int _retryCount = 0;
  bool _isImageAvailable = false;

  final Duration retryDuration = const Duration(seconds: 2);
  final int maxRetries = 3;

  Future<bool> isImageAvailable(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _checkImageAvailability() async {
    while (_retryCount < maxRetries) {
      final isAvailable = await isImageAvailable(widget.url!);
      if (isAvailable && mounted) {
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isImageAvailable = true;
            });
          });
        });
        break;
      }
      _retryCount++;
      await Future.delayed(retryDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${widget.url}",
      fit: widget.fit,
      placeholder: (context, url) {
        return _buildShimmer();
      },
      errorWidget: (c, s, o) {
        _checkImageAvailability();
        return _isImageAvailable
            ? CachedNetworkImage(imageUrl: "${widget.url}")
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Center(
                  child: widget.errorLoading
                      ? Lottie.asset(Images.starAnimation, fit: BoxFit.cover)
                      : Icon(Iconsax.image, size: 50.sp),
                ),
              );
      },
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).cardColor,
      highlightColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.05),
      child: Container(
        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3),
      ),
    );
  }
}
