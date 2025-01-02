import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_ai/view/base/common/primary_button.dart';
import 'package:matrix_ai/controller/image_upscale_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../../controller/background_remover_controller.dart';
import '../../../data/model/response/tools.dart';
import 'widgets/upscale_history.dart';

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
    bool isBackgroundRemover = widget.tool.backgroundRemover != null;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: (context.height * 0.52).sp,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: paddingDefault,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top * 2.8),
                    Text(
                      widget.tool.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8.sp),
                    Text(
                      widget.tool.description,
                      textAlign: TextAlign.center,
                      style: bodyMedium(context),
                    ),
                    SizedBox(height: 24.sp),
                    DottedBorder(
                      color: Theme.of(context).dividerColor,
                      dashPattern: const [30, 10],
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.round,
                      radius: Radius.circular(spacingDefault),
                      child: SizedBox(
                        height: 200.sp,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                            borderRadius: borderRadiusDefault,
                          ),
                          width: double.infinity,
                          child: InkWell(
                            borderRadius: borderRadiusDefault,
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
                                          'upload_image'.tr,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacingExtraLarge),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: (isBackgroundRemover ? 'remove_background' : 'upscale_image').tr,
                        onPressed: file != null
                            ? () {
                                if (isBackgroundRemover) {
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
                  ],
                ),
              ),
            ),
          ),
        ],
        body: UpscaleHistoryList(tool: widget.tool),
      ),
    );
  }
}
