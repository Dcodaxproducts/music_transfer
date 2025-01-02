import 'package:matrix_ai/imports.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const BottomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.vertical(top: Radius.circular(spacingDefault));
    return Hero(
      tag: 'button',
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80.sp,
          decoration: BoxDecoration(
            color: onPressed != null ? primaryColor : Theme.of(context).disabledColor,
            borderRadius: radius,
          ),
          child: Center(
            child: Text(
              text,
              style: bodyMedium(context).copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
