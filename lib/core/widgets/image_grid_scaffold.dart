import '../../imports.dart';

class ImageGridScaffold extends StatelessWidget {
  final Widget child;
  const ImageGridScaffold({super.key, required this.child});

  static const List<String> _demoImages = [
    'https://pixartai.dcodax.net/storage/239/1.jpg',
    'https://pixartai.dcodax.net/storage/240/WhatsApp-Image-2026-01-07-at-10.23.36.jpeg',
    'https://pixartai.dcodax.net/storage/241/2.jpg',
    'https://pixartai.dcodax.net/storage/244/img_20260107_053233_630948.jpg',
    'https://pixartai.dcodax.net/storage/245/img_20260107_053347_536887.jpg',
    'https://pixartai.dcodax.net/storage/246/img_20260107_053821_006624.jpg',
    'https://pixartai.dcodax.net/storage/249/img_20260107_054707_527462.jpg',
    'https://pixartai.dcodax.net/storage/251/img_20260107_060751_670780.jpg',
    'https://pixartai.dcodax.net/storage/253/img_20260107_061143_671644.jpg',
    'https://pixartai.dcodax.net/storage/252/img_20260107_060920_782890.jpg',
    'https://pixartai.dcodax.net/storage/254/img_20260107_061023_438446.jpg',
    'https://pixartai.dcodax.net/storage/255/img_20260107_061350_835160.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;
    final double horizontalPadding = isTablet ? 40.sp : 16.sp;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image Grid - full screen with clipping
          Positioned.fill(
            child: ClipRect(
              child: _ImageGridBackground(images: _demoImages, isTablet: isTablet),
            ),
          ),

          // Gradient Overlay - fades images at the bottom
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    context.theme.scaffoldBackgroundColor.withOpacity(0.7),
                    context.theme.scaffoldBackgroundColor,
                  ],
                  stops: const [0.0, 0.25, 0.45, 0.55],
                ),
              ),
              child: Align(alignment: Alignment.bottomCenter, child: child),
            ),
          ),

          // close button at top-left,
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.sp,
            right: 16.sp,
            child: InkWell(
              onTap: Get.back,
              borderRadius: AppRadius.circular32,
              child: Container(
                width: 40,
                height: 40.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.cardColor.withOpacity(0.8),
                ),
                child: Center(
                  child: Icon(Icons.close, size: 22.sp, color: context.font14.color),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Separate widget for the image grid background
/// Uses Stack with clipBehavior to properly clip overflow
class _ImageGridBackground extends StatelessWidget {
  final List<String> images;
  final bool isTablet;

  const _ImageGridBackground({required this.images, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double screenHeight = constraints.maxHeight;

        final double spacing = isTablet ? 10.sp : 8.sp;
        final int columnCount = isTablet ? 4 : 3;
        // Remove side padding - only spacing between columns
        final double columnWidth = (screenWidth - spacing * (columnCount - 1)) / columnCount;

        // Image height based on aspect ratio
        final double imageHeight = columnWidth * 1.35;

        // Calculate how many images needed to fill the visible area + extra for offset
        final int imagesPerColumn = ((screenHeight / (imageHeight + spacing)) + 3).ceil();

        // Different top offset for each column to create staggered effect
        final List<double> topOffsets = isTablet
            ? [imageHeight * 0.5, imageHeight * 0.15, imageHeight * 0.6, imageHeight * 0.3]
            : [imageHeight * 0.5, imageHeight * 0.1, imageHeight * 0.35];

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            for (int colIndex = 0; colIndex < columnCount; colIndex++)
              Positioned(
                // Start from edge, no left padding
                left: colIndex * (columnWidth + spacing),
                top: -topOffsets[colIndex % topOffsets.length],
                width: columnWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < imagesPerColumn; i++) ...[
                      _buildImageCard(
                        imageUrl: images[(colIndex * 3 + i) % images.length],
                        width: columnWidth,
                        height: imageHeight,
                      ),
                      SizedBox(height: spacing),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildImageCard({required String imageUrl, required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: AppRadius.circular24, color: Colors.grey[300]),
      child: ClipRRect(
        borderRadius: AppRadius.circular24,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => SizedBox.shrink(),
        ),
      ),
    );
  }
}
