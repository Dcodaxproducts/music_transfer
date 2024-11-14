import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final double? radius;
  final EdgeInsets? margin;
  final bool gradient;
  const PrimaryButton(
      {required this.text,
      this.onPressed,
      this.icon,
      this.color,
      this.textColor,
      this.margin,
      this.radius,
      this.gradient = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? primaryColor;
    final Color textColor = this.textColor ?? Colors.white;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ? secondaryGradient : null,
        borderRadius: BorderRadius.circular(radius ?? 16.sp),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gradient ? Colors.transparent : backgroundColor,
          minimumSize: Size(100.sp, 55.sp),
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 16.sp)),
          disabledBackgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
            Text(
              text.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

// outline button
class PrimaryOutlineButton extends StatelessWidget {
  final String? text;
  final void Function()? onPressed;
  final Widget? icon;
  final double? radius;
  final Color? textColor;
  final double? width;
  const PrimaryOutlineButton(
      {required this.onPressed,
      this.text,
      this.icon,
      this.radius,
      this.textColor,
      this.width,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = this.textColor ?? primaryColor;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size((width ?? 100).sp, 55.sp),
        side: BorderSide(color: Theme.of(context).dividerColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((radius ?? 16).sp)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
          if (text != null)
            Text(
              text!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: textColor),
            ),
        ],
      ),
    );
  }
}
