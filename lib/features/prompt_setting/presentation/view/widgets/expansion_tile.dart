import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/core/utils/style.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String value;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  const CustomExpansionTile(
      {required this.title, required this.children, required this.value, this.padding, super.key});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.only(top: spacingDefault),
      child: ExpansionTile(
        onExpansionChanged: (value) {
          setState(() {
            _isExpanded = value;
          });
        },
        backgroundColor: context.theme.cardColor,
        collapsedBackgroundColor: context.theme.cardColor,
        collapsedShape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value.tr,
              style: bodySmall(context).copyWith(
                color: context.theme.hintColor,
              ),
            ),
            SizedBox(width: 8.sp),
            Icon(
              _isExpanded ? Iconsax.arrow_down_1 : Iconsax.arrow_right_3,
              size: spacingDefault,
              color: context.theme.hintColor,
            ),
          ],
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: spacingDefault),
        childrenPadding: paddingDefault,
        title: Text(
          widget.title.tr,
          style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
        ),
        children: widget.children,
      ),
    );
  }
}
