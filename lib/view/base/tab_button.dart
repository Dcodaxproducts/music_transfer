import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/colors.dart';

class PrimaryTabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function() onPressed;
  final double radiusLeft;
  final double radiusRight;
  const PrimaryTabButton(
      {required this.text,
      required this.selected,
      required this.onPressed,
      required this.radiusLeft,
      required this.radiusRight,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.horizontal(
        right: Radius.circular(radiusRight),
        left: Radius.circular(radiusLeft),
      ),
      child: AnimatedContainer(
        height: 45.sp,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(radiusRight),
            left: Radius.circular(radiusLeft),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? Colors.white : null,
                ),
          ),
        ),
      ),
    );
  }
}
