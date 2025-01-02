import 'package:matrix_ai/imports.dart';

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
            valueIndicatorTextStyle:
                bodySmall(context).copyWith(color: context.theme.scaffoldBackgroundColor),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: bodySmall(context).color,
            inactiveColor: context.theme.dividerColor,
            onChanged: onChanged,
            label: value.toStringAsFixed(1),
          ),
        ),
        SizedBox(height: 5.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map(
                  (e) => Text(e.tr, style: bodySmall(context).copyWith(color: context.theme.hintColor)),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
