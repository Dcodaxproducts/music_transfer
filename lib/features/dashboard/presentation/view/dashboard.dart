import 'package:flutter/services.dart';
import 'package:pixart_app/features/dashboard/presentation/controller/dashboard_controller.dart';
import 'package:pixart_app/features/history/presentation/view/history_screen.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/core/widgets/confirmation_dialog.dart';
import 'package:pixart_app/features/paywall/presentation/widgets/subscription_button.dart';
import '../../../../core/widgets/primary_safe_area.dart';
import '../../../../core/widgets/action_button.dart';
import '../../../home/presentation/view/home.dart';
import '../../../inspirations/presentation/view/inspirations.dart';
import '../../../settings/presentation/view/settings.dart';
import '../../../tools/presentation/view/tools_screen.dart';
import '../../data/model/navigation_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<NavigationItem> _screens = [
    NavigationItem(icon: Iconsax.home_copy, activeIcon: Iconsax.home, child: const HomeScreen()),
    NavigationItem(icon: Iconsax.category_copy, activeIcon: Iconsax.category, child: const ToolScreen()),
    NavigationItem(
      icon: Iconsax.activity_copy,
      activeIcon: Iconsax.activity,
      child: const InspirationScreen(),
    ),
    NavigationItem(icon: Iconsax.setting_copy, activeIcon: Iconsax.setting, child: const SettingScreen()),
  ];

  final List<String> _titles = [AppConstants.appName, 'tools', 'inspirations', 'settings'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        int currentIndex = dashboardController.selectedIndex;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (value, result) {
            if (currentIndex != 0) {
              dashboardController.selectedIndex = 0;
            } else {
              ConfirmationDialog.show(
                title: 'exit_app'.tr,
                subtitle: 'exit_app_message'.tr,
                actionText: 'yes'.tr,
                onAccept: SystemNavigator.pop,
              );
            }
          },
          child: PrimaryAnnotatedRegion(
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Image.asset(
                        Images.logo,
                        width: 24.sp,
                        height: 24.sp,
                        color: context.font12.color,
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Text(_titles[currentIndex].tr),
                  ],
                ),
                centerTitle: false,
                actions: [
                  ActionButton.small(
                    icon: Iconsax.refresh_copy,
                    onPressed: () => launchScreen(const HistoryScreen()),
                  ),
                  SizedBox(width: 10.sp),
                  const SubsriptionButton(),
                  SizedBox(width: 10.sp),
                ],
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[currentIndex].child,
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) => dashboardController.selectedIndex = index,
                currentIndex: currentIndex,
                selectedItemColor: primaryColor,
                items: [
                  ..._screens.map((e) {
                    return BottomNavigationBarItem(
                      icon: Icon(e.icon),
                      activeIcon: Icon(e.activeIcon),
                      label: '',
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
