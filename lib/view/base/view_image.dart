import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:photo_view/photo_view.dart';

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
              backgroundDecoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
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
