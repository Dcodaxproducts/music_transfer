import 'package:shimmer/shimmer.dart';
import 'package:matrix_ai/imports.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  const CustomShimmer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.cardColor,
      highlightColor: bodyLarge(context).color!.withOpacity(0.05),
      child: child,
    );
  }
}
