import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/controller/dashboard_controller.dart';
import 'package:matrix_ai/view/base/confirmation_dialog.dart';
import 'package:matrix_ai/view/base/subscription_button.dart';
import '../../../utils/app_constants.dart';
import '../home/home.dart';
import '../inspirations/inspirations.dart';
import '../menu/menu.dart';
// import '../tools/tools.dart';
import 'widgets/navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<NavigationItem> _screens = [
    NavigationItem(icon: Iconsax.home, child: const HomeScreen()),
    NavigationItem(icon: Iconsax.activity, child: const InspirationScreen()),
    // NavigationItem(icon: Iconsax.category, child: const ToolScreen()),
    NavigationItem(icon: Iconsax.setting, child: const MenuScreen()),
  ];

  final List<String> _titles = [
    AppConstants.APP_NAME,
    'inspirations'.tr,
    // 'tools'.tr,
    'settings'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      int currentIndex = dashboardController.selectedIndex;
      return PopScope(
        canPop: false,
        onPopInvoked: (value) {
          if (currentIndex != 0) {
            dashboardController.selectedIndex = 0;
          } else {
            showConfirmationDialog(
              title: 'exit_app'.tr,
              subtitle: 'exit_app_message'.tr,
              actionText: 'yes'.tr,
              onAccept: SystemNavigator.pop,
            );
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(_titles[currentIndex]),
            actions: [
              // if (Platform.isIOS)
              const SubsriptionButton(),
              SizedBox(width: 10.sp),
            ],
          ),
          body: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[currentIndex].child,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GlasmorphicNavigationBar(
                  currentIndex: currentIndex,
                  navigationItems: _screens,
                  onTap: (index) {
                    dashboardController.selectedIndex = index;
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class NavigationItem {
  final IconData icon;
  final Widget child;
  NavigationItem({required this.icon, required this.child});
}
