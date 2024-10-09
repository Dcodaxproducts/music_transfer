import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/view/base/subscription_button.dart';
import '../../../utils/app_constants.dart';
import '../home/home.dart';
import '../inspirations/inspirations.dart';
import '../menu/menu.dart';
import '../tools/tools.dart';
import 'widgets/navigation_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final List<NavigationItem> _screens = [
    NavigationItem(icon: Iconsax.home, child: const HomeScreen()),
    NavigationItem(icon: Iconsax.activity, child: const InspirationScreen()),
    NavigationItem(icon: Iconsax.category, child: const ToolScreen()),
    NavigationItem(icon: Iconsax.setting, child: const MenuScreen()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.APP_NAME),
        actions: [
          const SubsriptionButton(),
          SizedBox(width: 10.sp),
        ],
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _screens[_currentIndex].child,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GlasmorphicNavigationBar(
              currentIndex: _currentIndex,
              navigationItems: _screens,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final Widget child;
  NavigationItem({required this.icon, required this.child});
}
