import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/view/base/expansion_tile.dart';
import '../../../../controller/settings_controller.dart';
import '../../../base/gradient_widget.dart';

class NegativePromptWidget extends StatelessWidget {
  final SettingsController con;
  const NegativePromptWidget({required this.con, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'negative_prompt',
      value: 'Add',
      children: [
        GradientBorder(
          padding: EdgeInsets.symmetric(
            horizontal: 12.sp,
            vertical: 5.sp,
          ),
          child: TextFormField(
            controller: con.negativePromptController,
            maxLines: 1,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: 'negative_prompt_message'.tr,
              border: InputBorder.none,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
              contentPadding: EdgeInsets.zero,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
