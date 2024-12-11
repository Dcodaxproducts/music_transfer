import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../data/model/response/tools.dart';
import '../../../../helper/navigation.dart';
import '../../../../utils/style.dart';
import '../../../base/divider.dart';
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
        mainAxisSpacing: 16.sp,
        crossAxisSpacing: 16.sp,
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
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image placeholder,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: borderRadius.topLeft),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(tool.image),
                  ),
                ),
              ),
            ),
            const CustomDivider(padding: 0),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tool.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    tool.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
