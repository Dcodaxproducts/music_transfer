import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/core/utils/style.dart';
import 'package:matrix_ai/core/widgets/gradient_widget.dart';

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
      child: GlassmorphicWidget(
        borderRadius: borderRadiusDefault,
        glassOpacity: 0.1,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          collapsedShape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
          shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.value.tr,
                style: bodySmall(context).copyWith(color: context.theme.hintColor),
              ),
              SizedBox(width: spacingDefault),
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
      ),
    );
  }
}
