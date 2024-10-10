import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/network_image.dart';
import '../../../../common/primary_button.dart';
import '../../../../controller/dashboard_controller.dart';
import '../../../../controller/settings_controller.dart';
import '../../../../data/model/response/inspiration.dart';
import '../../../../helper/navigation.dart';

class InspirationDialog extends StatelessWidget {
  final Inspiration inspiration;
  const InspirationDialog({required this.inspiration, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 450,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomNetworkImage(
                url: inspiration.image,
                fit: BoxFit.cover,
              ),
            ),

            // shadow,
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
            ),
            // close button
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: pop,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    inspiration.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'try_this'.tr,
                    onPressed: () {
                      final settings = SettingsController.find;
                      pop();
                      DashboardController.find.selectedIndex = 0;
                      settings.configModel =
                          settings.configModel.copyWith(seed: inspiration.seed);
                      settings.promptController.text = inspiration.prompt;
                      settings.seedController.text =
                          inspiration.seed.toString();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
