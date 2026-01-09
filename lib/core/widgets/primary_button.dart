import 'package:pixart_app/imports.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  const PrimaryButton({
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.textColor,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? primaryLight;
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
          if (isLoading) ...[
            SizedBox(
              height: 14.sp,
              width: 14.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2.sp,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
            SizedBox(width: 12.sp),
          ],
          Text(
            text.tr,
            style: context.font14.copyWith(fontWeight: FontWeight.w600, color: textColor),
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
  final Color? textColor;
  const PrimaryOutlineButton({required this.onPressed, this.text, this.icon, this.textColor, super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = this.textColor ?? primaryColor;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(100.sp, 50.sp),
        side: BorderSide(color: Theme.of(context).dividerColor),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.circular32),
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
