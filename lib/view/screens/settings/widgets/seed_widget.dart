import 'package:flutter/material.dart';
import '../../../base/common/textfield.dart';
import '../../../../controller/settings_controller.dart';
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
        CustomTextField(
          controller: con.seedController,
          keyboardType: TextInputType.number,
          onSaved: (value) {
            if (value != null) {
              con.configModel = con.configModel.copyWith(
                seed: value == '-1' || value.isEmpty ? null : int.parse(value),
              );
            }
          },
        ),
      ],
    );
  }
}
