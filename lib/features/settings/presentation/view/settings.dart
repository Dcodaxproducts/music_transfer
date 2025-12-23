import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/features/subscription/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/features/settings/presentation/view/widgets/app_version_widget.dart';
import 'package:pixart_app/features/review/presentation/view/rate_us_sheet.dart';
import 'package:pixart_app/features/html/html_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../imports.dart';
import '../../../language/presentation/view/language.dart';
import 'widgets/menu_item.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<Widget> _appMenuItems = [
    MenuItem(
      text: 'language',
      icon: Iconsax.language_circle,
      onTap: () => launchScreen(const LanguageScreen()),
    ),
    const NotificationTile(text: 'notifications', icon: Iconsax.notification),
  ];

  final List<Widget> _moreMenuItems = [
    if (SubscriptionController.find.products.isNotEmpty)
      MenuItem(
        text: 'manage_subscription',
        icon: Iconsax.crown_1,
        onTap: () => launchUrlString(AppConstants.manageSubscriptionsUrl),
      ),
    MenuItem(
      text: 'privacy_policy',
      icon: Iconsax.lock,
      onTap: () => launchScreen(HtmlScreen(html: SettingsController.find.settingModel.privacyPolicy)),
    ),
    MenuItem(
      text: 'terms_of_service',
      icon: Iconsax.info_circle,
      onTap: () => launchScreen(HtmlScreen(html: SettingsController.find.settingModel.termsAndConditions)),
    ),
    const MenuItem(text: 'rate_us', icon: Iconsax.star, onTap: showRateUsDialog),
    MenuItem(
      text: 'share_app',
      icon: Iconsax.share,
      onTap: () {
        String shareText =
            'Check out this amazing AI app\n\nAndroid:${AppConstants.androidAppUrl}\n\niOS:${AppConstants.iOSAppUrl}';
        Share.share(shareText);
      },
    ),
  ];

  //
  Widget get divider => Divider(color: context.theme.scaffoldBackgroundColor);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppPadding.padding16,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: AppRadius.circular16),
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
        DecoratedBox(
          decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: AppRadius.circular16),
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
