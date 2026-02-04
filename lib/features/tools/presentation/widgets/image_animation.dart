import 'package:pixart_app/imports.dart';

class ImageAnimation extends StatefulWidget {
  final String beforeImage;
  final String afterImage;

  /// If true → animation loops forever
  /// If false → plays [repeatCount] times
  final bool infinite;

  /// Used only when [infinite] is false
  final int repeatCount;

  final Duration duration;

  const ImageAnimation({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.infinite = true,
    this.repeatCount = 10,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<ImageAnimation> createState() => _ImageAnimationState();
}

class _ImageAnimationState extends State<ImageAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  int _cycleCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Moves from left → right → left
    _animation = Tween<double>(
      begin: -0.5,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.infinite) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
      _controller.addStatusListener(_handleAnimationStatus);
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
      _cycleCount++;

      if (_cycleCount < widget.repeatCount) {
        _controller.reverse();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pre-cache images to avoid frame drops
    precacheImage(CachedNetworkImageProvider(widget.beforeImage), context);
    precacheImage(CachedNetworkImageProvider(widget.afterImage), context);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          // final height = constraints.maxHeight;

          return AnimatedBuilder(
            animation: _animation,
            builder: (_, _) {
              final double dividerX = (width / 2) + (_animation.value * width);

              return Stack(
                fit: StackFit.expand,
                children: [
                  // AFTER image (right side hidden)
                  ClipRect(
                    clipper: _RightClipper(dividerX),
                    child: CachedNetworkImage(imageUrl: widget.afterImage, fit: BoxFit.cover),
                  ),

                  // BEFORE image (left side revealed)
                  ClipRect(
                    clipper: _LeftClipper(dividerX),
                    child: CachedNetworkImage(imageUrl: widget.beforeImage, fit: BoxFit.cover),
                  ),

                  // Moving divider line
                  Positioned(
                    left: dividerX,
                    top: 0,
                    bottom: 0,
                    child: Container(width: 4, color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  final double x;

  _LeftClipper(this.x);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, x, size.height);
  }

  @override
  bool shouldReclip(_) => true; // Fast for animations
}

class _RightClipper extends CustomClipper<Rect> {
  final double x;

  _RightClipper(this.x);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(x, 0, size.width - x, size.height);
  }

  @override
  bool shouldReclip(_) => true;
}
