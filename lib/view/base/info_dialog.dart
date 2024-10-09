import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/primary_button.dart';
import '../../helper/navigation.dart';
import 'divider.dart';

Future showInfoDialog({
  required String title,
  required String subtitle,
  BuildContext? context,
}) {
  return showDialog(
    context: context ?? Get.context!,
    builder: (context) => InfoDialog(
      title: title,
      subtitle: subtitle,
    ),
  );
}

class InfoDialog extends StatelessWidget {
  final String title, subtitle;
  const InfoDialog({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.tr,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const CustomDivider(padding: 20),
            Text(
              subtitle.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Center(
              child: PrimaryButton(
                text: 'understand'.tr,
                onPressed: pop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
