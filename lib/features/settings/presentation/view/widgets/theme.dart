import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/features/theme/presentation/controller/theme_controller.dart';
import 'package:matrix_ai/core/utils/colors.dart';
import '../../../../../core/utils/style.dart';

class ThemeTile extends StatefulWidget {
  const ThemeTile({super.key});

  @override
  State<ThemeTile> createState() => _ThemeTileState();
}

class _ThemeTileState extends State<ThemeTile> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        onExpansionChanged: (value) {
          setState(() {
            _isExpanded = value;
          });
        },
        tilePadding: EdgeInsets.symmetric(horizontal: spacingDefault),
        childrenPadding: paddingDefault,
        leading: Icon(Iconsax.moon, size: 18.sp, color: bodyMedium(context).color),
        title: Text('theme'.tr, style: bodyMedium(context)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<ThemeController>(builder: (con) {
              return Text(
                con.themeMode.toString().split('.').last.tr,
                style: bodySmall(context).copyWith(color: Theme.of(context).hintColor),
              );
            }),
            SizedBox(width: 8.sp),
            Icon(
              _isExpanded ? Iconsax.arrow_down_1 : Iconsax.arrow_right_3,
              size: spacingDefault,
              color: context.theme.hintColor,
            ),
          ],
        ),
        children: [
          GetBuilder<ThemeController>(builder: (con) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ThemeModeWidget(
                  text: 'system',
                  themeMode: ThemeMode.system,
                  selected: con.themeMode == ThemeMode.system,
                ),
                ThemeModeWidget(
                  text: 'light',
                  themeMode: ThemeMode.light,
                  selected: con.themeMode == ThemeMode.light,
                ),
                ThemeModeWidget(
                  text: 'dark',
                  themeMode: ThemeMode.dark,
                  selected: con.themeMode == ThemeMode.dark,
                ),
              ],
            );
          }),
        ]);
  }
}

class ThemeModeWidget extends StatelessWidget {
  final String text;
  final ThemeMode themeMode;
  final bool selected;
  const ThemeModeWidget({required this.text, required this.themeMode, required this.selected, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ThemeController.find.setThemeMode(themeMode),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.sp,
            height: 60.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? primaryColor : Theme.of(context).hintColor,
                width: 1.5.sp,
              ),
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: selected ? bodyMedium(context).color : Theme.of(context).hintColor,
            ),
          ),
          SizedBox(height: 8.sp),
          Text(
            text.tr,
            style: bodySmall(context),
          ),
        ],
      ),
    );
  }

  IconData get icon {
    switch (themeMode) {
      case ThemeMode.system:
        return Iconsax.monitor_mobbile;
      case ThemeMode.light:
        return Iconsax.sun_1;
      case ThemeMode.dark:
        return Iconsax.moon;
    }
  }
}
