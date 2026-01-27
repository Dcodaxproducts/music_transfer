import 'package:pixart_app/imports.dart';

class WatchAdsDialog extends StatelessWidget {
  final VoidCallback onWatchAd;
  final VoidCallback onUpgrade;

  const WatchAdsDialog({super.key, required this.onWatchAd, required this.onUpgrade});

  // Demo images for the stacked images display
  static const List<String> _demoImages = [
    'https://picsum.photos/200/200?random=1',
    'https://picsum.photos/200/200?random=2',
    'https://picsum.photos/200/200?random=3',
  ];

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onWatchAd,
    required VoidCallback onUpgrade,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WatchAdsDialog(onWatchAd: onWatchAd, onUpgrade: onUpgrade),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: AppPadding.padding24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stacked Images
            Center(child: _buildStackedImages()),

            SizedBox(height: 24.sp),

            // Title
            Text(
              'Continue generating by watching Ad.',
              textAlign: TextAlign.center,
              style: context.font18.copyWith(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12.sp),

            // Subtitle
            Text(
              'Keep your creativity flowing. Watch a short ad or upgrade your subscription to keep generating.',
              textAlign: TextAlign.center,
              style: context.font14.copyWith(color: context.theme.hintColor),
            ),

            SizedBox(height: 24.sp),

            // Watch an Ad button
            PrimaryButton(
              text: 'Watch an Ad',
              icon: Icon(Iconsax.video_play, color: context.theme.iconTheme.color),
              color: context.theme.canvasColor,
              textColor: context.font14.color,
              onPressed: () {
                Get.back();
                onWatchAd();
              },
            ),

            SizedBox(height: 12.sp),
            // Upgrade button
            PrimaryButton(
              text: 'Upgrade',
              icon: Icon(Iconsax.crown, color: Colors.white),
              onPressed: () {
                Get.back();
                onUpgrade();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStackedImages() {
    return SizedBox(
      height: 90.sp,
      width: 180.sp,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Left image (rotated left)
          Positioned(left: 0, child: Transform.rotate(angle: -0.15, child: _buildImageCard(_demoImages[0]))),

          // Right image (rotated right)
          Positioned(right: 0, child: Transform.rotate(angle: 0.15, child: _buildImageCard(_demoImages[2]))),

          // Center image (on top, no rotation)
          Positioned(child: _buildImageCard(_demoImages[1], isCenter: true)),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, {bool isCenter = false}) {
    final double size = isCenter ? 80.sp : 70.sp;
    return Container(
      width: size,
      height: size + 10.sp,
      decoration: BoxDecoration(
        borderRadius: AppRadius.circular16,
        border: Border.all(color: Get.context!.font14.color!, width: 3.sp),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.circular12,
        child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
