import '../../controller/settings_controller.dart';
import '../../../../aspect_ratio/data/model/aspect_ratio.dart';
import '../../../../../../imports.dart';
import 'expansion_tile.dart';

class AspectRatioSelectionWidget extends StatelessWidget {
  final SettingsController con;
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
            separatorBuilder: (_, _) => SizedBox(width: 10.sp),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final aspectRatio = aspectRatios[index];
              bool selected = con.configModel.aspectRatio == aspectRatio.id;
              return GestureDetector(
                onTap: () {
                  con.configModel = con.configModel.copyWith(
                    aspectRatio: aspectRatio.id,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.sp),
                    color: selected
                        ? context.font12.color
                        : context.theme.scaffoldBackgroundColor,
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
                        style: context.font12.copyWith(
                          color: selected
                              ? context.theme.scaffoldBackgroundColor
                              : null,
                        ),
                      ),
                      SizedBox(width: 16.sp),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  final bool selected;
  const AspectRatioBox({super.key, required this.ratio, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.sp),
      child: Container(
        width: ratio.width.toDouble(),
        height: ratio.height.toDouble(),
        color: selected
            ? Theme.of(context).scaffoldBackgroundColor
            : context.font14.color,
      ),
    );
  }
}
