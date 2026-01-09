import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/features/tools/presentation/widgets/image_animation.dart';
import '../../../../imports.dart';
import '../view/tools_detail_screen.dart';

class ToolCard extends StatelessWidget {
  final Tools tool;
  const ToolCard({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = AppRadius.circular8;
    return InkWell(
      onTap: () => launchScreen(ToolDetailScreen(tool: tool)),
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ImageAnimation(beforeImage: tool.beforeImage, afterImage: tool.afterImage),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 60.sp,
                width: double.infinity,
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: borderRadius.bottomLeft),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    tool.name.tr,
                    style: context.font12.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black.withOpacity(0.5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
