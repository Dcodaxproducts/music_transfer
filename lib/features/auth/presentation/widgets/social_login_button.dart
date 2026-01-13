import '../../../../imports.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? image;
  final VoidCallback onTap;
  final bool isDark;
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.image,
    this.isDark = false,
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
          if (image != null) Image.asset(image!, width: 24.sp, height: 24.sp),
          if (icon != null) Icon(icon, size: 24.sp, color: textColor),
          Text(label, style: context.font14.copyWith(color: textColor)),
          SizedBox(width: 16.sp),
        ],
      ),
    );
  }
}
