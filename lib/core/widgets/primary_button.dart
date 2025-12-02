import 'package:pixart_app/core/widgets/gradient_widget.dart';
import 'package:pixart_app/imports.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  const PrimaryButton({required this.text, this.onPressed, this.icon, this.color, this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? primaryColor;
    final Color textColor = this.textColor ?? Colors.white;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(100.sp, 50.sp),
        disabledBackgroundColor: backgroundColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
          Text(
            text.tr,
            style: context.font12.copyWith(fontWeight: FontWeight.w600, color: textColor),
          ),
        ],
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
  const PrimaryOutlineButton({
    required this.onPressed,
    this.text,
    this.icon,
    this.radius,
    this.textColor,
    this.width,
    super.key,
  });

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
              style: context.font12.copyWith(fontWeight: FontWeight.w600, color: textColor),
            ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;

  const GradientButton({required this.text, this.onPressed, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBorderContainer(
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.circular32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.cardColor.withOpacity(0.1),
          shadowColor: context.theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.circular32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: 8.sp)],
            Text(text, style: context.font12.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
