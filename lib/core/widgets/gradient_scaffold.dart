import 'package:matrix_ai/core/widgets/gradient_widget.dart';
import 'package:matrix_ai/imports.dart';
import 'dart:ui';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool extendBody;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const GradientScaffold({
    required this.body,
    this.appBar,
    this.extendBody = false,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          decoration: BoxDecoration(color: context.theme.cardColor.withOpacity(0.1)),
        ),

        // Blurred shapes
        Positioned(
          top: -100,
          left: -100,
          child: _buildBlurredShape(primaryColor.withOpacity(0.5), context.width, 300),
        ),

        Positioned(
          bottom: -100,
          right: -100,
          child: _buildBlurredShape(primaryColor.withOpacity(0.3), 250, 250),
        ),

        // Main content
        GlassmorphicWidget(
          borderRadius: BorderRadius.circular(0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: extendBody,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            appBar: appBar,
            body: body,
            bottomNavigationBar: bottomNavigationBar != null
                ? Theme(
                    data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                    child: bottomNavigationBar!,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBlurredShape(Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0.0)],
          stops: const [0.2, 1.0],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }
}
