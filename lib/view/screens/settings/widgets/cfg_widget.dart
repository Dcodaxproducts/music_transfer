import 'package:flutter/material.dart';
import '../../../../controller/settings_controller.dart';
import '../../../base/custom_slider.dart';
import '../../../base/expansion_tile.dart';

class CFGWidget extends StatelessWidget {
  final SettingsController con;
  const CFGWidget({required this.con, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: 'CFG Scale',
      value: con.configModel.guidanceScale.toStringAsFixed(0),
      children: [
        CustomSlider(
          value: con.configModel.guidanceScale,
          min: 1,
          max: 20,
          divisions: 199,
          labels: const ['Better Quality', 'Match Prompt'],
          onChanged: (value) {
            con.configModel = con.configModel.copyWith(
              guidanceScale: value,
            );
          },
        ),
      ],
    );
  }
}
