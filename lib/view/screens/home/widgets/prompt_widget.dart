import 'dart:math';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/imports.dart';
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
          'type_your_idea'.tr,
          style: bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: spacingSmall),
        GradientBorder(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text field
              TextFormField(
                maxLines: 5,
                maxLength: 1200,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'enter_prompt_message'.tr,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
                style: bodyMedium(context),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: con.promptController,
                onChanged: (value) => con.update(),
              ),
              SizedBox(height: spacingExtraSmall),
              // prompt options
              Row(
                children: [
                  // random insipiration
                  IconButton(
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      InspirationController inspirationCon = InspirationController.find;
                      Inspiration inspiration =
                          inspirationCon.inspirations[Random().nextInt(inspirationCon.inspirations.length)];
                      con.promptController.text = inspiration.prompt;
                      con.update();
                    },
                    icon: Icon(Iconsax.lamp_charge, size: 18.sp),
                  ),
                  const Spacer(),
                  if (con.promptController.text.isNotEmpty) ...[
                    SizedBox(width: 8.sp),
                    IconButton(
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        con.promptController.clear();
                        con.update();
                      },
                      icon: Icon(Icons.close, size: 18.sp),
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
