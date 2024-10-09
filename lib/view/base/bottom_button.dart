import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/colors.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const BottomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'button',
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          height: 80.sp,
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
