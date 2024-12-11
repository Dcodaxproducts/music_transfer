import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/common/network_image.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/controller/image_upscale_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../../controller/background_remover_controller.dart';
import '../../../data/model/response/tools.dart';
import '../../../data/model/response/upscale_response.dart';
import '../../base/queue_countdown.dart';
import 'widgets/countdown_widget.dart';

class UpscaleImageScreen extends StatefulWidget {
  final ToolModel tool;
  const UpscaleImageScreen({super.key, required this.tool});

  @override
  State<UpscaleImageScreen> createState() => _UpscaleImageScreenState();
}

class _UpscaleImageScreenState extends State<UpscaleImageScreen> {
  File? file;

  Future<void> _pickImage() async {
    final value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      file = File(value.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: (context.height * 0.58).sp,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius: borderRadius,
                      ),
                      width: double.infinity,
                      child: InkWell(
                        borderRadius: borderRadius,
                        onTap: _pickImage,
                        child: file != null
                            ? Image.file(
                                file!,
                                fit: BoxFit.contain,
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt, size: 40.sp),
                                    SizedBox(height: 8.sp),
                                    Text(
                                      'Upload Image',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.sp),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'Remove Background',
                        onPressed: file != null
                            ? () {
                                if (widget.tool.backgroundRemover != null) {
                                  BackgroundRemoverController.find
                                      .removeImageBackground(image: file!, tool: widget.tool);
                                } else {
                                  ImageUpscaleController.find.upscaleImage(image: file!, tool: widget.tool);
                                }
                              }
                            : null,
                        color: file != null ? primaryColor : Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.sp),
                ],
              ),
            ),
          ),
        ],
        body: HistoryList(tool: widget.tool),
      ),
    );
  }
}

class HistoryList extends StatelessWidget {
  final ToolModel tool;
  const HistoryList({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageUpscaleController>(builder: (upscaleController) {
      return GetBuilder<BackgroundRemoverController>(builder: (backgroundController) {
        List<UpscaleResponse> history = [];
        if (tool.backgroundRemover != null) {
          history = backgroundController.backgroundRemovalHistory;
        } else {
          history = upscaleController.upscaleHistory;
        }
        return Container(
          padding: pagePadding.copyWith(bottom: 0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: borderRadius.topLeft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // drag handle,
              Center(
                child: Container(
                  width: 40.sp,
                  height: 4.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                ),
              ),
              SizedBox(height: 8.sp),
              Text(
                'Recent'.tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.sp),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 16.sp),
                  itemCount: history.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.sp,
                    crossAxisSpacing: 16.sp,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return HistoryItem(response: history[index]);
                  },
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

class HistoryItem extends StatelessWidget {
  final UpscaleResponse response;
  const HistoryItem({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: UpscaleImageCountdownWidget(
          response: response,
          builder: (context, isCompleted, imageUrl, remainingTime, isRetrying) {
            return isCompleted
                ? CustomNetworkImage(url: imageUrl, errorLoading: true)
                : QueueCountdown(remainingTime: remainingTime, isRetrying: isRetrying, padding: false);
          },
        ),
      ),
    );
  }
}
