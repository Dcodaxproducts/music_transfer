import 'package:pixart_app/features/settings/presentation/widgets/theme.dart';
import 'package:pixart_app/features/settings/presentation/widgets/app_version_widget.dart';
import 'package:pixart_app/features/review/presentation/view/rate_us_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../core/widgets/context_menu.dart';
import '../../../../imports.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../../auth/presentation/view/login_screen.dart';
import '../../../language/presentation/view/language.dart';
import '../../../profile/presentation/view/profile_update.dart';
import '../widgets/credits_widget.dart';
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
      icon: Iconsax.language_circle_copy,
      onTap: () => launchScreen(const LanguageScreen()),
    ),
    ThemeTile(),
  ];

  final List<Widget> _moreMenuItems = [
    MenuItem(
      text: 'manage_subscription',
      icon: Iconsax.crown_1_copy,
      onTap: () => launchUrlString(AppConstants.manageSubscriptionsUrl),
    ),
    MenuItem(text: 'privacy_policy', icon: Iconsax.lock_copy, onTap: () {}),
    MenuItem(text: 'terms_of_service', icon: Iconsax.info_circle_copy, onTap: () {}),
    const MenuItem(text: 'rate_us', icon: Iconsax.star_copy, onTap: showRateUsDialog),
    MenuItem(
      text: 'share_app',
      icon: Iconsax.share_copy,
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
        LoginWidget(),
        SizedBox(height: 16.sp),
        CreditsWidget(),
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

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey _settingsKey = GlobalKey();

  (Offset, Size) _getWidgetPosition() {
    final RenderBox? renderBox = _settingsKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final Offset position = renderBox.localToGlobal(Offset.zero); // Global position
      final Size size = renderBox.size; // Also get the size if needed
      return (position, size);
    }
    return (Offset.zero, Size.zero);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        if (controller.isLoggedIn) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.sp),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(controller.user?.photoUrl ?? ''),
                  radius: 24.sp,
                  backgroundColor: context.theme.cardColor,
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.user?.name ?? '',
                        style: context.font14.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.sp),
                      Text(
                        controller.user?.email ?? '',
                        style: context.font12.copyWith(color: context.theme.hintColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.sp),
                IconButton(
                  key: _settingsKey,
                  icon: Icon(Iconsax.more_copy, color: context.theme.hintColor),
                  onPressed: () {
                    final (Offset position, Size size) = _getWidgetPosition();
                    showPrimaryContextMenu(
                      context: context,
                      details: LongPressStartDetails(
                        globalPosition: Offset(position.dx + size.width, position.dy),
                      ),
                      items: [
                        PrimaryContextMenu(
                          text: 'Profile',
                          icon: Iconsax.user_copy,
                          onTap: () => launchScreen(ProfileUpdateScreen()),
                        ),
                        PrimaryContextMenu(
                          text: 'Logout',
                          icon: Iconsax.logout_1_copy,
                          color: errorColor,
                          onTap: controller.logout,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }
        return PrimaryButton(onPressed: () => launchScreen(LoginScreen()), text: 'Login ');
      },
    );
  }
}
