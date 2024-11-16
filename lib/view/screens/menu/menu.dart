import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/html/html_screen.dart';
import 'package:matrix_ai/view/screens/subscription/subscription.dart';
import '../language/language.dart';
import 'widgets/theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<Widget> _appMenuItems = [
    MenuItem(
      text: 'language',
      icon: Iconsax.language_circle,
      onTap: () => launchScreen(const LanguageScreen()),
    ),
    const ThemeTile(),
  ];

  final List<Widget> _moreMenuItems = [
    MenuItem(
      text: 'subscription',
      icon: Iconsax.crown_1,
      onTap: () => launchScreen(const SubscriptionScreen()),
    ),
    MenuItem(
      text: 'privacy_policy',
      icon: Iconsax.lock,
      onTap: () => launchScreen(
        HtmlScreen(html: SettingsController.find.settingModel.privacyPolicy),
      ),
    ),
    MenuItem(
      text: 'terms_of_service',
      icon: Iconsax.info_circle,
      onTap: () => launchScreen(
        HtmlScreen(
            html: SettingsController.find.settingModel.termsAndConditions),
      ),
    ),
  ];

  //
  Widget get divider =>
      Divider(color: Theme.of(context).scaffoldBackgroundColor, height: 0);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: pagePadding,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: borderRadius,
          ),
          child: ListView.separated(
            itemCount: _appMenuItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => _appMenuItems[index],
          ),
        ),
        SizedBox(height: 16.sp),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: borderRadius,
          ),
          child: ListView.separated(
            itemCount: _moreMenuItems.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => _moreMenuItems[index],
          ),
        ),
        SizedBox(height: 16.sp),
        Center(
          child: Text(
            'Verson 1.0.0',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final String? subtile;
  final IconData icon;
  final Function()? onTap;
  const MenuItem(
      {required this.text,
      this.subtile,
      required this.icon,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      leading: Icon(
        icon,
        size: 18.sp,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      title: Text(
        text.tr,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: subtile != null
          ? Padding(
              padding: EdgeInsets.only(top: 5.sp),
              child: Text(
                subtile!.tr,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).hintColor),
              ),
            )
          : null,
      trailing: Icon(
        Iconsax.arrow_right_3,
        size: 16.sp,
        color: Theme.of(context).hintColor,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
    );
  }
}
