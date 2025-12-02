import 'package:pixart_app/imports.dart';

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
            valueIndicatorTextStyle: context.font12.copyWith(color: context.theme.scaffoldBackgroundColor),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: context.font12.color,
            inactiveColor: context.theme.dividerColor,
            onChanged: onChanged,
            label: value.toStringAsFixed(1),
          ),
        ),
        SizedBox(height: 5.sp),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map((e) => Text(e.tr, style: context.font12.copyWith(color: context.theme.hintColor)))
                .toList(),
          ),
        ),
      ],
    );
  }
}
