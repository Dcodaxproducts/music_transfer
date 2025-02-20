import 'package:matrix_ai/imports.dart';
import '../../../../data/model/response/tools.dart';
import '../../upscale_image/upscale_image.dart';

class ToolsGridWidget extends StatelessWidget {
  final List<ToolModel> tools;
  const ToolsGridWidget({super.key, required this.tools});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: spacingDefault,
        crossAxisSpacing: spacingDefault,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final tool = tools[index];
        return ToolCard(tool: tool);
      },
    );
  }
}

class ToolCard extends StatelessWidget {
  final ToolModel tool;
  const ToolCard({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchScreen(UpscaleImageScreen(tool: tool)),
      borderRadius: borderRadiusDefault,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadiusDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image placeholder
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: borderRadiusDefault.topLeft),
                child: tool.animation,
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.name.tr,
                    style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: spacingSmall),
                  Text(tool.description.tr, style: bodySmall(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// https://p16-capcut-va.ibyteimg.com/tos-maliva-i-6rr7idwo9f-us/1699603859699.on2~tplv-6rr7idwo9f-image.image
// https://images.wondershare.com/virtulook/articles/best-ai-background-removal-tools-1.jpg
