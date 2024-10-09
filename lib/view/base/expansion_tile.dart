import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/utils/style.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String value;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  const CustomExpansionTile(
      {required this.title,
      required this.children,
      required this.value,
      this.padding,
      super.key});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.only(top: 16.sp),
      child: ExpansionTile(
        onExpansionChanged: (value) {
          setState(() {
            _isExpanded = value;
          });
        },
        backgroundColor: Theme.of(context).cardColor,
        collapsedBackgroundColor: Theme.of(context).cardColor,
        collapsedShape: RoundedRectangleBorder(borderRadius: borderRadius),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.value.tr,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).hintColor),
            ),
            SizedBox(width: 8.sp),
            Icon(
              _isExpanded ? Iconsax.arrow_down_1 : Iconsax.arrow_right_3,
              size: 16.sp,
              color: Theme.of(context).hintColor,
            ),
          ],
        ),
        tilePadding: EdgeInsets.symmetric(horizontal: 16.sp),
        childrenPadding: pagePadding,
        title: Text(
          widget.title.tr,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        children: widget.children,
      ),
    );
  }
}
