import 'package:matrix_ai/imports.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final bool gradient;
  const PrimaryButton(
      {required this.text,
      this.onPressed,
      this.icon,
      this.color,
      this.textColor,
      this.gradient = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? primaryColor;
    final Color textColor = this.textColor ?? Colors.white;
    return DecoratedBox(
      decoration:
          BoxDecoration(gradient: gradient ? secondaryGradient : null, borderRadius: borderRadiusDefault),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: gradient ? Colors.transparent : backgroundColor,
          minimumSize: Size(100.sp, 50.sp),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
          disabledBackgroundColor: backgroundColor,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: spacingSmall)],
            Text(
              text.tr,
              style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600, color: textColor),
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
      {required this.onPressed, this.text, this.icon, this.radius, this.textColor, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = this.textColor ?? primaryColor;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size((width ?? 100).sp, 55.sp),
        side: BorderSide(color: Theme.of(context).dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((radius ?? 16).sp)),
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
                  ?.copyWith(fontWeight: FontWeight.w600, color: textColor),
            ),
        ],
      ),
    );
  }
}
