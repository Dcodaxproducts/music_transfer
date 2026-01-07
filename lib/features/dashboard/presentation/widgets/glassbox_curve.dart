import 'dart:ui';
import 'package:pixart_app/imports.dart';

class GlassBoxCurve extends StatelessWidget {
  final Widget child;
  const GlassBoxCurve({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cardColor = context.theme.scaffoldBackgroundColor;
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7.sp, sigmaY: 7.sp),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cardColor, cardColor.withOpacity(0.2)],
              stops: const [0.0, 1.0],
            ),
            boxShadow: [
              BoxShadow(color: cardColor.withOpacity(0.2), blurRadius: 30, offset: const Offset(2, 2)),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
