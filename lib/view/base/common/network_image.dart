import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../utils/style.dart';

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
  static final Map<String, bool> _blackImageCache = {};

  int _retryCount = 0;
  bool _isImageAvailable = false;
  bool _isBlackImage = false;

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

  void _checkIfImageIsBlack(ImageProvider imageProvider) {
    if (_blackImageCache.containsKey(widget.url)) {
      // Use cached value if available
      if (mounted) {
        setState(() {
          _isBlackImage = _blackImageCache[widget.url]!;
        });
      }
      return;
    }

    // Decode the image as a byte buffer and analyze pixels
    ImageStream stream = imageProvider.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) async {
        final image = imageInfo.image;
        final isBlack = await _analyzeImagePixels(image);

        if (mounted) {
          setState(() {
            _isBlackImage = isBlack;
            _blackImageCache[widget.url!] = isBlack; // Cache result
          });
        }
      }),
    );
  }

  Future<bool> _analyzeImagePixels(ui.Image image) async {
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return false;

    final bytes = byteData.buffer.asUint8List();
    int blackPixelCount = 0;
    int totalPixels = image.width * image.height;

    // Iterate through pixel data (RGBA format)
    for (int i = 0; i < bytes.length; i += 4) {
      final r = bytes[i];
      final g = bytes[i + 1];
      final b = bytes[i + 2];

      // Check if the pixel is black
      if (r < 10 && g < 10 && b < 10) {
        blackPixelCount++;
      }
    }

    // Check if the image is predominantly black (>90% black pixels)
    return blackPixelCount / totalPixels > 0.9;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "${widget.url}",
      imageBuilder: (context, imageProvider) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 100), () {
            _checkIfImageIsBlack(imageProvider);
          });
        });
        // If the image is black, show a custom UI
        if (_isBlackImage) {
          return Container(
            padding: paddingDefault,
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Center(
              child: Text(
                "nsfw_content_detected".tr,
                textAlign: TextAlign.center,
                style: bodyMedium(context).copyWith(color: textColorDark),
              ),
            ),
          );
        }

        // Otherwise, display the image normally
        return Image(
          image: imageProvider,
          fit: widget.fit,
          colorBlendMode: widget.color == null ? null : BlendMode.darken,
          color: widget.color,
        );
      },
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
