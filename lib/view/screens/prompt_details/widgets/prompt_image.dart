import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import '../../../../common/network_image.dart';
import '../../../../helper/navigation.dart';
import '../../../base/view_image.dart';
import 'prompt_edit.dart';
import 'prompt_report.dart';

class PromptImageWidget extends StatelessWidget {
  const PromptImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationController>(builder: (controller) {
      final result = controller.promptResponse;
      int width = result?.meta.w ?? 0;
      int height = result?.meta.h ?? 0;
      String url = '';
      if (result?.output.isEmpty ?? true) {
        url = result?.futureLinks.first ?? '';
      } else {
        url = result?.output.first ?? '';
      }
      return InkWell(
        onTap: () => launchScreen(ViewImage(url)),
        child: AspectRatio(
          aspectRatio: width / height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // image
              Hero(
                tag: url,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16.sp),
                  ),
                  child: CustomNetworkImage(url: url, errorLoading: true),
                ),
              ),

              const BackButton(),
              const PromptEditButton(),
              const PromptReportButton(),
            ],
          ),
        ),
      );
    });
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.sp,
      left: 10,
      child: InkWell(
        onTap: pop,
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.arrow_back,
            size: 22.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
