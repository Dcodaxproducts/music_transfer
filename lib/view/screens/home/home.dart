import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/home/widgets/models_widget.dart';
import 'widgets/history_view.dart';
import 'widgets/prompt_options.dart';
import 'widgets/prompt_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (con) {
      return ListView(
        padding: pagePadding.copyWith(top: 5.sp),
        children: [
          PromptWidget(con: con),
          const ModelWidget(),
          const PromptSettingsWidget(),
          Padding(
            padding: EdgeInsets.only(top: 32.sp),
            child: PrimaryButton(
              text: 'Create',
              icon: Icon(
                Iconsax.magicpen,
                size: 18.sp,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          const HitoryView(),
          SizedBox(height: 80.sp),
        ],
      );
    });
  }
}
