import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pixart_app/features/dashboard/presentation/controller/dashboard_controller.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/features/subscription/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/core/widgets/confirmation_dialog.dart';
import 'package:pixart_app/features/subscription/presentation/view/widgets/subscription_button.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../modules/image_generation/home/presentation/view/home.dart';
import '../../../../modules/image_generation/inspirations/presentation/view/inspirations.dart';
import '../../../settings/presentation/view/settings.dart';
import '../../../subscription/presentation/view/subscription.dart';
import '../../../tools/presentation/view/tools.dart';
import '../../data/model/navigation_item.dart';
import 'widgets/navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<NavigationItem> _screens = [
    NavigationItem(icon: Iconsax.home, child: const HomeScreen()),
    NavigationItem(icon: Iconsax.category, child: const ToolScreen()),
    NavigationItem(icon: Iconsax.activity, child: const InspirationScreen()),
    NavigationItem(icon: Iconsax.setting, child: const SettingScreen()),
  ];

  final List<String> _titles = [
    AppConstants.appName,
    'tools',
    'inspirations',
    'settings',
  ];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (SubscriptionController.find.products.isNotEmpty &&
          !SubscriptionController.find.isPro) {
        Future.delayed(const Duration(seconds: 2), () => showPremiumSheet());
      }
      SettingsController.find.saveShowAppOpen();
    });
    super.initState();
  }

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
              backgroundColor: Colors.transparent,
              title: Text(_titles[currentIndex].tr),
              actions: [
                if (SubscriptionController.find.products.isNotEmpty) ...[
                  const SubsriptionButton(),
                  SizedBox(width: 10.sp),
                ],
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
      },
    );
  }
}
