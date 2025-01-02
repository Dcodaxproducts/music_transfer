import '../../../../controller/settings_controller.dart';
import '../../../../data/model/body/aspect_ratio.dart';
import '../../../../imports.dart';
import '../../../base/expansion_tile.dart';

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
            separatorBuilder: (_, __) => SizedBox(width: 10.sp),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final aspectRatio = aspectRatios[index];
              bool selected = con.configModel.aspectRatio == aspectRatio.id;
              return GestureDetector(
                  onTap: () {
                    con.configModel = con.configModel.copyWith(aspectRatio: aspectRatio.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(spacingExtraLarge),
                      color: selected ? bodySmall(context).color : context.theme.scaffoldBackgroundColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: spacingDefault),
                        SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: FittedBox(child: AspectRatioBox(ratio: aspectRatio, selected: selected)),
                        ),
                        SizedBox(width: spacingSmall),
                        Text(
                          aspectRatio.aspectRatio,
                          style: bodySmall(context)
                              .copyWith(color: selected ? context.theme.scaffoldBackgroundColor : null),
                        ),
                        SizedBox(width: spacingDefault),
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
        color: selected ? Theme.of(context).scaffoldBackgroundColor : bodyMedium(context).color,
      ),
    );
  }
}
