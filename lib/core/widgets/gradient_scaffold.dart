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
    bool isDarkMode = context.theme.brightness == Brightness.dark;
    return Builder(builder: (context) {
      return Stack(
        children: [
          // Base dark gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [const Color(0xFF1A1A2E), const Color(0xFF0F0F1A)]
                    : [const Color(0xFFFAFAFA), const Color(0xFFEFEFEF)],
              ),
            ),
          ),

          // Blurred neon shapes
          Positioned(
            top: -100,
            right: -50,
            child: _buildBlurredShape(primaryColor.withOpacity(0.7), 200, 300),
          ),

          Positioned(
            bottom: -80,
            left: -30,
            child: _buildBlurredShape(secondaryColor.withOpacity(0.3), 250, 250),
          ),

          // Main content
          Scaffold(
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
        ],
      );
    });
  }

  Widget _buildBlurredShape(Color color, double width, double height) {
    return Container(
      width: width.sp,
      height: height.sp,
      decoration: BoxDecoration(
        gradient: RadialGradient(colors: [color, color.withOpacity(0.0)], stops: const [0.2, 1.0]),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 70.sp, sigmaY: 70.sp),
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }
}
