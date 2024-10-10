import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import '../../../../controller/inspiration_controller.dart';
import '../../../../data/model/response/inspiration.dart';
import '../../../base/gradient_widget.dart';

class PromptWidget extends StatelessWidget {
  final SettingsController con;
  const PromptWidget({required this.con, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type your idea'.tr,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.sp),
        GradientBorder(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text field
              TextFormField(
                maxLines: 5,
                maxLength: 1200,
                decoration: InputDecoration(
                  hintText: 'enter_prompt_message'.tr,
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: con.promptController,
                onChanged: (value) => con.update(),
              ),
              SizedBox(height: 5.sp),
              // prompt options
              Row(
                children: [
                  // _micButton(),

                  // random insipiration
                  IconButton(
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                    onPressed: () {
                      InspirationController inspirationCon =
                          InspirationController.find;
                      Inspiration inspiration = inspirationCon.inspirations[
                          Random().nextInt(inspirationCon.inspirations.length)];
                      con.promptController.text = inspiration.prompt;
                      con.update();
                    },
                    icon: Icon(Iconsax.lamp_charge, size: 22.sp),
                  ),
                  const Spacer(),
                  if (con.promptController.text.isNotEmpty) ...[
                    SizedBox(width: 8.sp),
                    IconButton(
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      onPressed: () {
                        con.promptController.clear();
                        con.update();
                      },
                      icon: const Icon(Icons.close, size: 16),
                    ),
                  ]
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
