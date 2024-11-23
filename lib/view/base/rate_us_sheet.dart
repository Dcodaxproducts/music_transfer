import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:matrix_ai/common/primary_button.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../common/snackbar.dart';
import '../../controller/review_controller.dart';
import '../../utils/style.dart';

Future showRateUsSheet() => Get.dialog(const RateUsSheet());

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
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        padding: pagePadding,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${'do_you_like'.tr} ${AppConstants.APP_NAME}?'.tr,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.sp),
            Text(
              'your_feedback_will_help_us_improve_our_service_for_you'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 1; i <= 5; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        _rating = i;
                      });
                    },
                    child: Icon(
                      Iconsax.star1,
                      size: 40.sp,
                      color: i <= _rating
                          ? Colors.orange
                          : Theme.of(context).disabledColor,
                    ),
                  ),
              ],
            ),
            if (_rating < 4)
              Padding(
                padding: EdgeInsets.only(top: 16.sp),
                child: TextField(
                  controller: _review,
                  decoration: InputDecoration(
                    hintText: 'add_a_comment'.tr,
                    border: OutlineInputBorder(borderRadius: borderRadius),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 32.sp),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'submit'.tr,
                  onPressed: _submitReview,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submitReview() {
    if (_rating > 3) {
      launchUrlString(AppConstants.APP_LINK,
          mode: LaunchMode.externalApplication);
      return;
    }
    if (_review.text.isNotEmpty) {
      ReviewController.find
          .saveReview(_rating, _review.text.trim())
          .then((value) => Get.back());
    } else {
      showToast('please_write_your_review'.tr);
    }
  }
}
