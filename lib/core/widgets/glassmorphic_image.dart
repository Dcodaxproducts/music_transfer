import 'package:pixart_app/imports.dart';
import 'dart:ui';
import 'network_image.dart';

class GlassmorphicImage extends StatelessWidget {
  final Widget child;
  final String url;

  const GlassmorphicImage({required this.child, required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // glassmorphism image
        CustomNetworkImage(url: url),
        SizedBox(
          width: context.width,
          height: context.height,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.sp, sigmaY: 30.sp),
            child: Container(decoration: const BoxDecoration(color: Colors.transparent)),
          ),
        ),

        child,
      ],
    );
  }
}
