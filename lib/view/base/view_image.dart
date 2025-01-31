import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:matrix_ai/imports.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class ViewImage extends StatelessWidget {
  final String url;
  const ViewImage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leadingWidth: 40.sp),
      body: Padding(
        padding: EdgeInsets.only(bottom: 10.sp),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Hero(
            tag: url,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              imageProvider: CachedNetworkImageProvider(url),
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Iconsax.image, size: 50.sp));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ImageViewWithErrorHandling extends StatefulWidget {
  final String url;
  const ImageViewWithErrorHandling({super.key, required this.url});

  @override
  State<ImageViewWithErrorHandling> createState() => _ImageViewWithErrorHandlingState();
}

class _ImageViewWithErrorHandlingState extends State<ImageViewWithErrorHandling> {
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
      final isAvailable = await isImageAvailable(widget.url);
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
    return PhotoView(
      backgroundDecoration: BoxDecoration(color: context.theme.cardColor),
      imageProvider: CachedNetworkImageProvider(widget.url),
      loadingBuilder: (context, event) {
        return _buildShimmer();
      },
      errorBuilder: (context, error, stackTrace) {
        _checkImageAvailability();
        return _isImageAvailable
            ? CachedNetworkImage(imageUrl: widget.url)
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: Center(child: Lottie.asset(Images.starAnimation, fit: BoxFit.cover)),
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
