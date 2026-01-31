import '../../../../imports.dart';

class EmptyHistory extends StatefulWidget {
  const EmptyHistory({super.key});

  @override
  State<EmptyHistory> createState() => _EmptyHistoryState();
}

class _EmptyHistoryState extends State<EmptyHistory> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnimatedImageStack(),
          SizedBox(height: 8.sp),
          Text("ai_image".tr, style: context.font18),
          SizedBox(height: 4.sp),
          Text(
            "describe_image_start_creating".tr,
            textAlign: TextAlign.center,
            style: context.font14.copyWith(color: context.theme.hintColor),
          ),
        ],
      ),
    );
  }
}

/// An animated image stack widget that shows overlapping images.
/// Initially animates to expand, and toggles between expanded/collapsed on tap.
class AnimatedImageStack extends StatefulWidget {
  /// List of image URLs or asset paths to display
  final List<String>? images;

  /// Size of the center image
  final double imageSize;

  /// Border radius for the images
  final double borderRadius;

  /// Duration for the animation
  final Duration animationDuration;

  const AnimatedImageStack({
    super.key,
    this.images,
    this.imageSize = 90,
    this.borderRadius = 16,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedImageStack> createState() => _AnimatedImageStackState();
}

class _AnimatedImageStackState extends State<AnimatedImageStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  // Default sample images if not provided
  static const List<String> _defaultImages = [
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400', // Woman portrait
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400', // Fashion model
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400', // Man portrait
  ];

  List<String> get _images => widget.images ?? _defaultImages;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.animationDuration, vsync: this);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    // Initially animate to expand after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
        setState(() => _isExpanded = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.imageSize.sp;
    final double stackWidth = size * 2.2;
    final double stackHeight = size * 2.0;

    return GestureDetector(
      onTap: _toggleExpanded,
      child: SizedBox(
        width: stackWidth,
        height: stackHeight,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(alignment: Alignment.center, children: _buildImages(size));
          },
        ),
      ),
    );
  }

  List<Widget> _buildImages(double size) {
    final List<Widget> imageWidgets = [];
    final int imageCount = _images.length;

    // Define the transforms for each image position based on screenshot
    // [offset X, offset Y, rotation angle in degrees, scale]
    // Left image: goes up-left, rotated counterclockwise
    // Center image: stays in place, no rotation
    // Right image: goes down-right, rotated clockwise
    final List<List<double>> transforms = [
      [-45, 20, -12, 0.9], // Left image - up an,d left
      [0, 0, 0, 1.0], // Center image (primary)
      [45, 25, 12, 0.9], // Right image - down and right
    ];

    for (int i = 0; i < imageCount && i < 3; i++) {
      final double offsetX = transforms[i][0] * _animation.value;
      final double offsetY = transforms[i][1] * _animation.value;
      final double rotation = transforms[i][2] * _animation.value * (3.14159 / 180);
      final double baseScale = transforms[i][3];
      final double scale = 1.0 + (baseScale - 1.0) * _animation.value;

      // Z-order: center image should be on top
      final int zIndex = i == 1 ? 2 : (i == 0 ? 0 : 1);

      imageWidgets.add(
        _PositionedImage(
          key: ValueKey(i),
          imageUrl: _images[i],
          size: size,
          offsetX: offsetX.sp,
          offsetY: offsetY.sp,
          rotation: rotation,
          scale: scale,
          borderRadius: widget.borderRadius.sp,
          zIndex: zIndex,
          opacity: i == 1 ? 1.0 : _animation.value,
        ),
      );
    }

    // Sort by z-index to ensure proper layering
    imageWidgets.sort((a, b) {
      final aIndex = (a as _PositionedImage).zIndex;
      final bIndex = (b as _PositionedImage).zIndex;
      return aIndex.compareTo(bIndex);
    });

    return imageWidgets;
  }
}

class _PositionedImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double offsetX;
  final double offsetY;
  final double rotation;
  final double scale;
  final double borderRadius;
  final int zIndex;
  final double opacity;

  const _PositionedImage({
    super.key,
    required this.imageUrl,
    required this.size,
    required this.offsetX,
    required this.offsetY,
    required this.rotation,
    required this.scale,
    required this.borderRadius,
    required this.zIndex,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(offsetX, offsetY)
        ..rotateZ(rotation)
        ..scale(scale),
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Container(
          padding: EdgeInsets.all(4.sp),
          decoration: BoxDecoration(
            color: context.theme.canvasColor,
            borderRadius: BorderRadius.circular(borderRadius + 4),
          ),
          child: Container(
            width: size,
            height: size * 1.2, // Slightly taller for portrait aspect
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade800,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.white54),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
