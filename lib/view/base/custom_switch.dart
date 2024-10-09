import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String enableText;
  final String disableText;
  const CustomSwitch({
    required this.value,
    required this.onChanged,
    required this.enableText,
    required this.disableText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: value ? primaryColor : Colors.grey,
              borderRadius: BorderRadius.circular(5),
              gradient: value ? primaryGradient : null,
              boxShadow: value
                  ? const [
                      BoxShadow(
                        color: primaryColor,
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value ? enableText : disableText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            inactiveThumbColor: Colors.grey,
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
