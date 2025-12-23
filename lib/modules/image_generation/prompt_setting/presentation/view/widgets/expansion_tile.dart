import '../../../../../../imports.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String value;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  const CustomExpansionTile({
    required this.title,
    required this.children,
    required this.value,
    this.padding,
    super.key,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.only(top: 16.sp),
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: AppRadius.circular16),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          collapsedShape: AppRadius.circular16Shape,
          shape: AppRadius.circular16Shape,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value.tr,
                style: context.font12.copyWith(color: context.theme.hintColor),
              ),
              SizedBox(width: 16.sp),
              Icon(
                _isExpanded ? Iconsax.arrow_down_1 : Iconsax.arrow_right_3,
                size: 16.sp,
                color: context.theme.hintColor,
              ),
            ],
          ),
          tilePadding: EdgeInsets.symmetric(horizontal: 16.sp),
          childrenPadding: AppPadding.padding16,
          title: Text(
            widget.title.tr,
            style: context.font14.copyWith(fontWeight: FontWeight.w600),
          ),
          children: widget.children,
        ),
      ),
    );
  }
}
