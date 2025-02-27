import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/features/language/presentation/controller/localization_controller.dart';
import 'package:matrix_ai/core/utils/colors.dart';
import 'package:matrix_ai/features/dashboard/presentation/view/widgets/glassbox_curve.dart';
import '../../../../../core/utils/style.dart';
import '../dashboard.dart';

class GlasmorphicNavigationBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final List<NavigationItem> navigationItems;
  const GlasmorphicNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.navigationItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingDefault,
      child: Center(
        child: GlassBoxCurve(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sliding Indicator for the selected button
              GetBuilder<LocalizationController>(builder: (con) {
                bool isLtr = con.isLtr;
                double alignment = -1 + (2 / (navigationItems.length - 1)) * currentIndex;
                if (!isLtr) alignment *= -1;
                return AnimatedAlign(
                  alignment: Alignment(alignment, 0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: context.width / navigationItems.length - 10.sp,
                    height: 53.sp,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(40.sp),
                      gradient: secondaryGradient,
                    ),
                  ),
                );
              }),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < navigationItems.length; i++)
                    Expanded(
                      child: NavigationButton(
                        icon: navigationItems[i].icon,
                        selected: currentIndex == i,
                        onPressed: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final void Function() onPressed;

  const NavigationButton({
    required this.icon,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.sp),
        ),
        minimumSize: Size(0, 55.sp),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          icon,
          key: ValueKey(selected),
          color: selected ? Colors.white : bodyMedium(context).color,
          size: selected ? 24.sp : 20.sp,
        ),
      ),
    );
  }
}
