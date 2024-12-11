import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/colors.dart';

class ViewImage extends StatefulWidget {
  final String url;
  const ViewImage(this.url, {super.key});

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  bool _isBlackImage = false;

  @override
  void initState() {
    super.initState();
    _checkIfImageIsBlack(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leadingWidth: 40.sp),
      body: Padding(
        padding: EdgeInsets.only(bottom: 10.sp),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Hero(
            tag: widget.url,
            child: _isBlackImage
                ? Center(
                    child: Text(
                      "nsfw_content_detected".tr,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColordark),
                    ),
                  )
                : PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    imageProvider: CachedNetworkImageProvider(widget.url),
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Icon(Iconsax.image, size: 50.sp));
                    },
                  ),
          ),
        ),
      ),
    );
  }

  void _checkIfImageIsBlack(String imageUrl) {
    final imageProvider = CachedNetworkImageProvider(imageUrl);

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) async {
        final image = imageInfo.image;
        final isBlack = await _analyzeImagePixels(image);
        if (mounted) {
          setState(() {
            _isBlackImage = isBlack;
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

    for (int i = 0; i < bytes.length; i += 4) {
      final r = bytes[i];
      final g = bytes[i + 1];
      final b = bytes[i + 2];

      if (r < 10 && g < 10 && b < 10) {
        blackPixelCount++;
      }
    }

    // Check if more than 90% of the pixels are black
    return blackPixelCount / totalPixels > 0.9;
  }
}
