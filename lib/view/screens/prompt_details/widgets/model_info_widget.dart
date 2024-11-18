import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:view_more/view_more.dart';
import '../../../../data/model/response/api_response.dart';
import '../../../../data/model/response/model.dart';
import '../../../../helper/date_converter.dart';

class ModelInfoWidget extends StatelessWidget {
  const ModelInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationController>(
      builder: (con) {
        PromptResponse response = con.promptResponse!;
        Model model = response.model!;
        return Column(
          children: [
            Row(
              children: [
                // model image
                CircleAvatar(
                  radius: 20.sp,
                  backgroundImage: CachedNetworkImageProvider(model.image),
                ),
                SizedBox(width: 10.sp),
                // model name,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.sp),
                      Text(
                        DateConverter.convertDate(response.createdAt!),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.sp),
            ViewMore(
              response.meta.prompt.trim(),
              trimLines: 2,
              trimMode: Trimer.line,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
              trimExpandedText: ' View Less',
              trimCollapsedText: ' View More',
            ),
          ],
        );
      },
    );
  }
}
