import 'package:pixart_app/imports.dart';

class GradientWidget extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  const GradientWidget({required this.child, this.gradient, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => (gradient ?? primaryGradient).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}
