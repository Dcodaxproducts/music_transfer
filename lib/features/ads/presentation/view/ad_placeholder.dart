import 'package:pixart_app/core/widgets/shimmer.dart';
import 'package:pixart_app/imports.dart';

class NativeAdPlaceholder extends StatelessWidget {
  final double height;
  const NativeAdPlaceholder({super.key, required this.height});
  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        padding: AppPadding.padding16,
        alignment: Alignment.center,
        height: height.sp,
        width: double.infinity,
        color: Theme.of(context).cardColor,
      ),
    );
  }
}

class BannerAdPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  const BannerAdPlaceholder({super.key, this.width = double.infinity, this.height = 64});
  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: height.sp,
        width: width.sp,
        padding: AppPadding.padding16,
        alignment: Alignment.center,
        color: Theme.of(context).cardColor,
      ),
    );
  }
}
