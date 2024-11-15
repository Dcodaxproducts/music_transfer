import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/textfield.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../utils/style.dart';
import '../../../base/expansion_tile.dart';

class SeedWidget extends StatelessWidget {
  final SettingsController con;
  const SeedWidget({required this.con, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'seed',
      value: 'change',
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          child: CustomTextField(
            padding: EdgeInsets.zero,
            controller: con.seedController,
            keyboardType: TextInputType.number,
            onSaved: (value) {
              if (value != null) {
                con.configModel = con.configModel.copyWith(
                  seed:
                      value == '-1' || value.isEmpty ? null : int.parse(value),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
