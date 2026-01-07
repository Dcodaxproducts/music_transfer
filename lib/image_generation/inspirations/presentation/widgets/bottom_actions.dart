import 'package:flutter/services.dart';
import 'package:pixart_app/image_generation/inspirations/data/model/inspiration.dart';
import '../../../../core/widgets/share_button.dart';
import '../../../../features/dashboard/presentation/controller/dashboard_controller.dart';
import '../../../../imports.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';

class InspirationActions extends StatelessWidget {
  final Inspiration inspiration;
  const InspirationActions({super.key, required this.inspiration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.sp,
        children: [
          ShareButton(url: inspiration.image),
          ActionButton(
            icon: Iconsax.copy,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: inspiration.prompt));
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryLight,
              visualDensity: VisualDensity(horizontal: 1, vertical: -1),
              minimumSize: Size(120.sp, 50.sp),
            ),
            onPressed: () {
              final settings = SettingsController.find;
              pop();
              DashboardController.find.selectedIndex = 0;
              settings.promptController.text = inspiration.prompt;
            },
            child: Text('try_now'.tr),
          ),
        ],
      ),
    );
  }
}
