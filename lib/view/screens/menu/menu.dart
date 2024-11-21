import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/base/appVersion_widget.dart';
import 'package:matrix_ai/view/screens/html/html_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
    // MenuItem(
    //   text: 'notifications',
    //   icon: Iconsax.notification,
    //   notification: true,
    //   onTap: () {
    //     SettingsController setting = SettingsController.find;
    //     setting.configModel = setting.configModel.copyWith(
    //         notificationsEnabled: !setting.configModel.notificationsEnabled);
    //   },
    // ),
  ];

  final List<Widget> _moreMenuItems = [
    // if (Platform.isIOS)
    MenuItem(
      text: 'manage_subscription',
      icon: Iconsax.crown_1,
      onTap: () => launchUrlString(AppConstants.MANAGE_SUBSCRIPTIONS_URL),
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
    MenuItem(
      text: 'share_app',
      icon: Iconsax.share,
      onTap: () {
        String shareText =
            'Check out this amazing AI app\n\nAndroid:${AppConstants.ANDROID_APP_URL}\n\niOS:${AppConstants.IOS_APP_URL}';
        Share.share(shareText);
      },
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
            padding: EdgeInsets.zero,
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
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => divider,
            itemBuilder: (context, index) => _moreMenuItems[index],
          ),
        ),
        const AppVersionWidget(),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final String? subtile;
  final IconData icon;
  final Function()? onTap;
  final bool notification;
  const MenuItem(
      {required this.text,
      this.subtile,
      required this.icon,
      required this.onTap,
      this.notification = false,
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
      trailing: notification
          ? GetBuilder<SettingsController>(builder: (setting) {
              bool notification = setting.configModel.notificationsEnabled;
              return Switch(
                value: notification,
                onChanged: (value) {
                  setting.configModel =
                      setting.configModel.copyWith(notificationsEnabled: value);
                },
                activeColor: Theme.of(context).primaryColor,
              );
            })
          : Icon(
              Iconsax.arrow_right_3,
              size: 16.sp,
              color: Theme.of(context).hintColor,
            ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
    );
  }
}
