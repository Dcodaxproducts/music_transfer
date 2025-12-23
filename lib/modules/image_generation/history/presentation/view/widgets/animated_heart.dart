import 'package:pixart_app/core/widgets/gradient_widget.dart';
import '../../../../../../imports.dart';

class AnimatedHeart extends StatefulWidget {
  final double size;
  const AnimatedHeart({super.key, this.size = 100.0});

  @override
  AnimatedHeartState createState() => AnimatedHeartState();
}

class AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Animation duration
    )..repeat(reverse: true); // Repeat with reverse animation

    // Define the animation (scaling effect)
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value, // Scale animation
          child: child,
        );
      },
      child: GradientWidget(
        gradient: secondaryGradient,
        child: Icon(Iconsax.heart5, color: Colors.white, size: widget.size.sp),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
