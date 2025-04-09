import 'package:matrix_ai/modules/image_generation/prompt_setting/presentation/view/widgets/expansion_tile.dart';
import '../../controller/settings_controller.dart';
import '../../../../../../imports.dart';
import '../../../../../../core/widgets/gradient_widget.dart';

class NegativePromptWidget extends StatelessWidget {
  final SettingsController con;
  const NegativePromptWidget({required this.con, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'negative_prompt',
      value: 'add',
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
              contentPadding: EdgeInsets.zero,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: bodyMedium(context),
          ),
        ),
      ],
    );
  }
}
