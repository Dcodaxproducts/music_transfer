import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final List<String> labels;
  final Function(double)? onChanged;
  const CustomSlider({
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.labels,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.sp),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            valueIndicatorTextStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: Theme.of(context).textTheme.bodyMedium?.color,
            inactiveColor: Theme.of(context).dividerColor,
            onChanged: onChanged,
            label: value.toStringAsFixed(1),
          ),
        ),
        SizedBox(height: 5.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map(
                  (e) => Text(
                    e.tr,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
