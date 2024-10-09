import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/colors.dart';

class CustomNetworkImage extends StatefulWidget {
  final String? url;
  final bool history;
  final BoxFit fit;
  final double loadingRadius;
  const CustomNetworkImage(
      {required this.url,
      this.history = false,
      this.fit = BoxFit.cover,
      this.loadingRadius = 0,
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
      placeholder: (c, s) {
        return ClipRRect(
            borderRadius: BorderRadius.circular(widget.loadingRadius),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.grey[300],
              ),
            ));
      },
      errorWidget: (c, s, o) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.loadingRadius),
            color: Theme.of(context).cardColor,
          ),
          child: widget.history
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: primaryGradient,
                    ),
                    child: const Icon(
                      Iconsax.timer,
                      size: 16,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  'Your image is being generated...\nTap to View image.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                )),
        );
      },
    );
  }
}
