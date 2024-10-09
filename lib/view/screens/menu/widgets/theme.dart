import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/theme_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import '../../../../utils/style.dart';

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
        backgroundColor: Theme.of(context).cardColor,
        collapsedBackgroundColor: Theme.of(context).cardColor,
        collapsedShape: RoundedRectangleBorder(borderRadius: borderRadius),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        tilePadding: EdgeInsets.symmetric(horizontal: 16.sp),
        childrenPadding: pagePadding,
        leading: Icon(
          Iconsax.moon,
          size: 18.sp,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        title: Text('Theme', style: Theme.of(context).textTheme.bodyMedium),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<ThemeController>(builder: (con) {
              return Text(
                con.themeMode.toString().split('.').last.capitalizeFirst!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).hintColor),
              );
            }),
            SizedBox(width: 8.sp),
            Icon(
              _isExpanded ? Iconsax.arrow_down_1 : Iconsax.arrow_right_3,
              size: 16.sp,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
        children: [
          GetBuilder<ThemeController>(builder: (con) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ThemeModeWidget(
                  text: 'System',
                  themeMode: ThemeMode.system,
                  selected: con.themeMode == ThemeMode.system,
                ),
                ThemeModeWidget(
                  text: 'Light',
                  themeMode: ThemeMode.light,
                  selected: con.themeMode == ThemeMode.light,
                ),
                ThemeModeWidget(
                  text: 'Dark',
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
  const ThemeModeWidget(
      {required this.text,
      required this.themeMode,
      required this.selected,
      super.key});

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
              color: selected
                  ? Theme.of(context).textTheme.bodyMedium?.color
                  : Theme.of(context).hintColor,
            ),
          ),
          SizedBox(height: 8.sp),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
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
        return Iconsax.sun;
      case ThemeMode.dark:
        return Iconsax.moon;
    }
  }
}
