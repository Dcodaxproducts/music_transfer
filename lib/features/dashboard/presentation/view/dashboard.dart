import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:pixart_app/features/dashboard/presentation/controller/dashboard_controller.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/core/widgets/confirmation_dialog.dart';
import 'package:pixart_app/features/paywall/presentation/widgets/subscription_button.dart';
import '../../../../core/widgets/primary_safe_area.dart';
import '../../../../image_gen/home/presentation/view/home.dart';
import '../../../../image_gen/inspirations/presentation/view/inspirations.dart';
import '../../../paywall/presentation/controller/subscription_controller.dart';
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
    NavigationItem(icon: Iconsax.home, child: const HomeScreen()),
    NavigationItem(icon: Iconsax.category, child: const ToolScreen()),
    NavigationItem(icon: Iconsax.activity, child: const InspirationScreen()),
    NavigationItem(icon: Iconsax.setting, child: const SettingScreen()),
  ];

  final List<String> _titles = [AppConstants.appName, 'tools', 'inspirations', 'settings'];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!SubscriptionController.find.isPro) {
        SubscriptionController.find.showPaywallIfNeeded();
      }
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
                    return BottomNavigationBarItem(icon: Icon(e.icon), activeIcon: Icon(e.icon), label: '');
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

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const NavBarItem({super.key, required this.icon, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      // width: 50.sp,
      // height: 50.sp,
      decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? primaryColor : Colors.transparent),
      child: Icon(icon, color: selected ? Colors.white : Colors.grey),
    );
  }
}
