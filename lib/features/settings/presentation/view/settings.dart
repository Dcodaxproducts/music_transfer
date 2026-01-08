import 'package:pixart_app/features/settings/presentation/widgets/theme.dart';
import 'package:pixart_app/features/settings/presentation/widgets/app_version_widget.dart';
import 'package:pixart_app/features/review/presentation/view/rate_us_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../imports.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../language/presentation/view/language.dart';
import '../widgets/menu_item.dart';

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
    ThemeTile(),
  ];

  final List<Widget> _moreMenuItems = [
    MenuItem(
      text: 'manage_subscription',
      icon: Iconsax.crown_1,
      onTap: () => launchUrlString(AppConstants.manageSubscriptionsUrl),
    ),
    MenuItem(
      text: 'privacy_policy',
      icon: Iconsax.lock,
      onTap: () {
        // TODO: Update privacy policy link
      },
    ),
    MenuItem(
      text: 'terms_of_service',
      icon: Iconsax.info_circle,
      onTap: () {
        // TODO: Update terms of service link
      },
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
      padding: AppPadding.padding16.copyWith(top: 24.sp),
      children: [
        PrimaryButton(onPressed: () => launchScreen(LoginScreen()), text: 'Login '),
        SizedBox(height: 16.sp),
        Container(
          padding: AppPadding.padding12,
          decoration: BoxDecoration(
            borderRadius: AppRadius.circular16,
            border: Border.all(color: context.theme.dividerColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generation credits left',
                      style: context.font12.copyWith(color: context.theme.hintColor),
                    ),
                    SizedBox(height: 8.sp),
                    Text('100', style: context.font16.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                decoration: BoxDecoration(
                  color: primaryLight.withOpacity(0.15),
                  borderRadius: AppRadius.circular12,
                ),
                child: Row(
                  children: [
                    Image.asset(Images.sparkle, width: 14.sp, height: 14.sp, color: primaryLight),
                    SizedBox(width: 4.sp),
                    Text('Get credits', style: context.font10.copyWith(color: primaryLight)),
                    SizedBox(width: 4.sp),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.sp),
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
