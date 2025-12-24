import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/modules/bg_remover/presentation/view/remove_bg.dart';
import '../../../../imports.dart';
import '../../../../modules/image_upscale/presentation/view/upscale_image.dart';

class ToolsGrid extends StatelessWidget {
  const ToolsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('image_editing'.tr, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: 12.sp),
        SizedBox(
          height: 200.sp,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 12.sp),
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ToolCard(
                  tool: ToolModel.upscaleImageTool,
                  screen: UpscaleImageScreen(tool: ToolModel.upscaleImageTool),
                );
              } else {
                return ToolCard(
                  tool: ToolModel.backgroundRemoverTool,
                  screen: BgRemoverScreen(tool: ToolModel.backgroundRemoverTool),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ToolCard extends StatelessWidget {
  final ToolModel tool;
  final Widget screen;
  const ToolCard({super.key, required this.tool, required this.screen});

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = AppRadius.circular8;
    return SizedBox(
      width: 150.sp,
      child: InkWell(
        onTap: () => launchScreen(screen),
        borderRadius: borderRadius,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              tool.animation ?? SizedBox.shrink(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    borderRadius: BorderRadius.vertical(bottom: borderRadius.bottomLeft),
                  ),
                  child: Text(tool.name.tr, style: context.font12.copyWith(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
