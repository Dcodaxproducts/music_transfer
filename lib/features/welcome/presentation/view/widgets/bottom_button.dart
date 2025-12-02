import 'package:pixart_app/imports.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const BottomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.vertical(top: Radius.circular(16.sp));
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
              style: context.font14.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
