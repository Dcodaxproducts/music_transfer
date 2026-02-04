import 'package:shimmer/shimmer.dart';
import '../../imports.dart';

class PrimaryNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final bool lowQuality;
  const PrimaryNetworkImage({super.key, required this.url, this.fit = BoxFit.cover, this.lowQuality = false});

  @override
  Widget build(BuildContext context) {
    // 572 x 724
    int? width;
    int? height;
    if (lowQuality) {
      width = 572;
      height = 724;
    }
    return CachedNetworkImage(
      imageUrl: "$url",
      fit: fit,
      memCacheWidth: width,
      memCacheHeight: height,
      maxWidthDiskCache: width,
      maxHeightDiskCache: height,
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
      highlightColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.05),
      child: Container(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3)),
    );
  }
}
