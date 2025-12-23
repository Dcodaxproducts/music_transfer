import 'dart:ui';
import 'package:pixart_app/imports.dart';

class UpscaleAnimation extends StatefulWidget {
  const UpscaleAnimation({super.key});

  @override
  UpscaleAnimationState createState() => UpscaleAnimationState();
}

class UpscaleAnimationState extends State<UpscaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _repeatCount = 0;
  final int _maxRepeats = 10;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 1,
      ), // Move right
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 1,
      ), // Back to center
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -1.0),
        weight: 1,
      ), // Move left
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: 0.0),
        weight: 1,
      ), // Back to center
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_repeatCount < _maxRepeats - 1) {
          _repeatCount++;
          _controller.reset();
          _controller.forward();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double imageWidth = constraints.maxWidth;
        double imageHeight = constraints.maxHeight;

        return SizedBox(
          width: imageWidth,
          height: imageHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Original Image
              Image.asset(Images.toolsImage, fit: BoxFit.cover),

              // Blur Effect with Moving Line
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double linePosition =
                      (imageWidth / 2) + (_animation.value * imageWidth / 2);

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Blurred Image (Masked to Left Side)
                      Positioned.fill(
                        child: ClipRect(
                          clipper: LeftSideClipper(linePosition),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ),

                      // Moving Line Effect
                      Positioned(
                        left: linePosition,
                        child: Container(
                          width: 5,
                          height: imageHeight,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Clipper to mask the left side of the moving line
class LeftSideClipper extends CustomClipper<Rect> {
  final double linePosition;

  LeftSideClipper(this.linePosition);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, linePosition, size.height);
  }

  @override
  bool shouldReclip(LeftSideClipper oldClipper) {
    return oldClipper.linePosition != linePosition;
  }
}
