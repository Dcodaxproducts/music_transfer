import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../data/model/body/aspect_ratio.dart';
import '../../../base/expansion_tile.dart';

class AspectRatioSelectionWidget extends StatelessWidget {
  final SetttingsController con;
  const AspectRatioSelectionWidget({
    required this.con,
    required this.selectedAspectRatio,
    super.key,
  });

  final String selectedAspectRatio;

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'aspect_ratio',
      value: selectedAspectRatio,
      children: [
        SizedBox(
          height: 35.sp,
          child: ListView.separated(
            itemCount: aspectRatios.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.sp),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final aspectRatio = aspectRatios[index];
              bool selected = con.configModel.aspectRatio == aspectRatio.id;
              return GestureDetector(
                  onTap: () {
                    con.configModel =
                        con.configModel.copyWith(aspectRatio: aspectRatio.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.sp),
                      color: selected
                          ? Theme.of(context).textTheme.bodySmall?.color
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 16.sp),
                        SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: FittedBox(
                            child: AspectRatioBox(
                              ratio: aspectRatio,
                              selected: selected,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          aspectRatio.aspectRatio,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: selected
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : null,
                              ),
                        ),
                        SizedBox(width: 16.sp),
                      ],
                    ),
                  ));
            },
          ),
        )
      ],
    );
  }
}

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  final bool selected;
  const AspectRatioBox({
    super.key,
    required this.ratio,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.sp),
      child: Container(
        width: ratio.width.toDouble(),
        height: ratio.height.toDouble(),
        color: selected
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).textTheme.bodyMedium!.color,
      ),
    );
  }
}
