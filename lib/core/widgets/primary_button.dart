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

class SocialLoginButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? image;
  final VoidCallback onTap;
  final bool isDark;
  final bool isLoading;
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.image,
    this.isDark = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColor = isDark ? context.font14.color : context.theme.cardColor;
    final Color? textColor = isDark ? context.theme.scaffoldBackgroundColor : context.font14.color;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: Size(400.sp, 60.sp), backgroundColor: backgroundColor),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLoading)
            SizedBox(
              width: 24.sp,
              height: 24.sp,
              child: CircularProgressIndicator(color: textColor, strokeWidth: 2.sp),
            )
          else if (image != null && !isLoading)
            Image.asset(image!, width: 24.sp, height: 24.sp),

          if (icon != null) Icon(icon, size: 24.sp, color: textColor),
          Text(label.tr, style: context.font14.copyWith(color: textColor)),
          SizedBox(width: 16.sp),
        ],
      ),
    );
  }
}
