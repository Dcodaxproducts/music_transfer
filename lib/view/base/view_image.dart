import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix_ai/imports.dart';
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
