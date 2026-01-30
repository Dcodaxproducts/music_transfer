import 'package:shimmer/shimmer.dart';
import 'package:pixart_app/imports.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  const CustomShimmer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.cardColor,
      highlightColor: context.theme.canvasColor,
      child: child,
    );
  }
}
