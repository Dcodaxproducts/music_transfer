import 'package:pixart_app/imports.dart';

class BackgroundRemoverAnimation extends StatefulWidget {
  const BackgroundRemoverAnimation({super.key});

  @override
  BackgroundRemoverAnimationState createState() => BackgroundRemoverAnimationState();
}

class BackgroundRemoverAnimationState extends State<BackgroundRemoverAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _repeatCount = 0;
  final int _maxRepeats = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3));

    // Using TweenSequence for starting from center and ending at center
    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: -0.5), weight: 1.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: -0.5, end: 0.5), weight: 1.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.5, end: 0.0), weight: 1.0),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_repeatCount < _maxRepeats) {
          _repeatCount++;
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (_repeatCount < _maxRepeats) {
          _repeatCount++;
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
          child: ColoredBox(
            color: context.theme.cardColor,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Clipped Image with Background (Hidden from Left)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double linePosition = (imageWidth / 2) + (_animation.value * imageWidth);

                    return ClipRect(
                      clipper: RightSideClipper(linePosition),
                      child: Image.asset(Images.bg_remover, fit: BoxFit.cover),
                    );
                  },
                ),

                // Clipped Image without Background (Revealed from Left)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double linePosition = (imageWidth / 2) + (_animation.value * imageWidth);

                    return ClipRect(
                      clipper: LeftSideClipper(linePosition),
                      child: Image.asset(Images.bg_remover_removed, fit: BoxFit.cover),
                    );
                  },
                ),

                // Moving Line Effect
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    double linePosition = (imageWidth / 2) + (_animation.value * imageWidth);

                    return Positioned(
                      left: linePosition,
                      child: Container(width: 5, height: imageHeight, color: Colors.white.withOpacity(0.8)),
                    );
                  },
                ),
              ],
            ),
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

// Clipper to hide the left part of the background-removed image
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

// Clipper to hide the right part of the original image
class RightSideClipper extends CustomClipper<Rect> {
  final double linePosition;

  RightSideClipper(this.linePosition);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(linePosition, 0, size.width - linePosition, size.height);
  }

  @override
  bool shouldReclip(RightSideClipper oldClipper) {
    return oldClipper.linePosition != linePosition;
  }
}
