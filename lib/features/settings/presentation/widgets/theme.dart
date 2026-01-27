import '../../../../imports.dart';

class ThemeTile extends StatefulWidget {
  const ThemeTile({super.key});

  @override
  State<ThemeTile> createState() => _ThemeTileState();
}

class _ThemeTileState extends State<ThemeTile> {
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) => _isExpanded.value = value,
      tilePadding: EdgeInsets.symmetric(horizontal: 16.sp),
      childrenPadding: AppPadding.padding16,
      leading: Icon(Iconsax.moon_copy, size: 18.sp, color: context.font14.color),
      title: Text('theme'.tr, style: context.font14),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetBuilder<ThemeController>(
            builder: (con) {
              return Text(
                con.themeMode.toString().split('.').last.tr,
                style: context.font12.copyWith(color: Theme.of(context).hintColor),
              );
            },
          ),
          SizedBox(width: 8.sp),
          ValueListenableBuilder<bool>(
            valueListenable: _isExpanded,
            builder: (context, value, child) {
              return Icon(
                value ? Iconsax.arrow_down_1_copy : Iconsax.arrow_right_3_copy,
                size: 16.sp,
                color: context.theme.hintColor,
              );
            },
          ),
        ],
      ),
      children: [
        GetBuilder<ThemeController>(
          builder: (con) {
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
          },
        ),
      ],
    );
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
              border: Border.all(color: selected ? primaryColor : Theme.of(context).hintColor, width: 1.5.sp),
            ),
            child: Icon(
              icon,
              size: 18.sp,
              color: selected ? context.font14.color : Theme.of(context).hintColor,
            ),
          ),
          SizedBox(height: 8.sp),
          Text(text.tr, style: context.font12),
        ],
      ),
    );
  }

  IconData get icon {
    switch (themeMode) {
      case ThemeMode.system:
        return Iconsax.monitor_mobbile_copy;
      case ThemeMode.light:
        return Iconsax.sun_1_copy;
      case ThemeMode.dark:
        return Iconsax.moon_copy;
    }
  }
}
