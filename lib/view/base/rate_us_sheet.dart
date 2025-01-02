import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/view/base/common/primary_button.dart';
import 'package:matrix_ai/controller/generation_controller.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'common/snackbar.dart';
import '../../controller/review_controller.dart';
import '../../utils/style.dart';

Future showRateUsDialog() {
  return Get.dialog(const RateUsSheet());
}

Future showConditionalRateUsDialog() {
  if (!ReviewController.find.isReviewed &&
      ReviewController.find.canShowDialog() &&
      GenerationController.find.dailyGenerationCount >= 3) {
    return Get.dialog(const RateUsSheet());
  } else {
    return Future.value();
  }
}

class RateUsSheet extends StatefulWidget {
  const RateUsSheet({super.key});

  @override
  State<RateUsSheet> createState() => _RateUsSheetState();
}

class _RateUsSheetState extends State<RateUsSheet> {
  int _rating = 5;
  final TextEditingController _review = TextEditingController();

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: paddingDefault,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${'do_you_like'.tr} ${AppConstants.APP_NAME}?'.tr,
              style: titleMedium(context),
            ),
            SizedBox(height: spacingSmall),
            Text(
              'your_feedback_will_help_us_improve_our_service_for_you'.tr,
              style: bodyMedium(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacingDefault),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rating = i;
                      });
                    },
                    child: Icon(
                      Iconsax.star1,
                      size: 40.sp,
                      color: i <= _rating ? Colors.orange : context.theme.disabledColor,
                    ),
                  ),
              ],
            ),
            if (_rating < 4)
              Padding(
                padding: EdgeInsets.only(top: spacingDefault),
                child: TextField(
                  controller: _review,
                  decoration: InputDecoration(
                    hintText: 'add_a_comment'.tr,
                    border: OutlineInputBorder(borderRadius: borderRadiusDefault),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadiusDefault,
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  maxLines: 3,
                  style: bodyMedium(context),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: spacingExtraLarge),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(text: 'submit'.tr, onPressed: _submitReview),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submitReview() {
    if (_rating > 3) {
      launchUrlString(AppConstants.APP_LINK, mode: LaunchMode.externalApplication);
      ReviewController.find.setReviewed();
      Get.back();
      return;
    }
    if (_review.text.isNotEmpty) {
      ReviewController.find.saveReview(_rating, _review.text.trim()).then((value) {
        ReviewController.find.setReviewed();
        Get.back();
      });
    } else {
      showToast('please_write_your_review'.tr);
    }
  }
}
