import 'package:pixart_app/imports.dart';

class GradientWidget extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  const GradientWidget({required this.child, this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          (gradient ?? primaryGradient).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: child,
    );
  }
}

class GradientBorderContainer extends StatelessWidget {
  /// The child widget to be displayed inside the gradient border
  final Widget child;

  /// The width of the gradient border
  final double borderWidth;

  /// Padding inside the border
  final EdgeInsets? padding;

  /// The border radius of the container
  final BorderRadius? borderRadius;

  /// Glass blur intensity
  final double blurIntensity;

  /// Glass opacity
  final double glassOpacity;

  const GradientBorderContainer({
    super.key,
    required this.child,
    this.borderWidth = 1.5,
    this.padding,
    this.borderRadius,
    this.blurIntensity = 10.0,
    this.glassOpacity = 0.01,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? AppRadius.circular16;
    return CustomPaint(
      painter: GradientBorderPainter(
        gradient: primaryGradient,
        strokeWidth: borderWidth.sp,
        borderRadius: radius.topLeft.x,
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius.topLeft.x - borderWidth),
          child: Padding(padding: padding ?? AppPadding.padding16, child: child),
        ),
      ),
    );
  }
}

/// Custom painter to draw only the gradient border
class GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;

  GradientBorderPainter({required this.gradient, required this.strokeWidth, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    // Create rectangular area for gradient
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Create rounded rectangle
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Create smaller rounded rectangle for the "hole"
    final RRect innerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth, strokeWidth, size.width - strokeWidth * 2, size.height - strokeWidth * 2),
      Radius.circular(borderRadius - strokeWidth),
    );

    // Create path for the border
    final Path path = Path()
      ..addRRect(rrect)
      ..addRRect(innerRRect)
      ..fillType = PathFillType.evenOdd;

    // Get the paint with gradient
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Draw the gradient border
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
