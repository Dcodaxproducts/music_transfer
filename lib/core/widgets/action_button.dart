import '../../imports.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final bool isLoading;
  final Function() onPressed;
  final Color? color;

  //
  final bool useCanvas;
  final double size;
  final double iconSize;

  const ActionButton({
    super.key,
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
    this.color,
    this.useCanvas = false,
    this.size = 50,
    this.iconSize = 18,
  });

  const ActionButton.small({
    super.key,
    required this.icon,
    this.isLoading = false,
    this.color,
    required this.onPressed,
    this.useCanvas = true,
    this.size = 36,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = useCanvas ? context.theme.canvasColor : context.theme.cardColor;
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.circular32,
      child: Container(
        width: size.sp,
        height: size.sp,
        decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: (iconSize - 2).sp,
                  height: (iconSize - 2).sp,
                  child: CircularProgressIndicator(strokeWidth: 2.sp, color: color ?? context.font14.color),
                )
              : Icon(icon, size: iconSize.sp, color: color ?? context.font14.color),
        ),
      ),
    );
  }
}
