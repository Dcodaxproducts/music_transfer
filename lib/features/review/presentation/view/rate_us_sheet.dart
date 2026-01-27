import 'package:url_launcher/url_launcher_string.dart';
import '../../../../imports.dart';
import '../controller/review_controller.dart';

Future showRateUsDialog() {
  return Get.dialog(const RateUsSheet());
}

Future showConditionalRateUsDialog() {
  if (!ReviewController.find.isReviewed && ReviewController.find.canShowDialog()) {
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
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${'do_you_like'.tr} ${AppConstants.appName}?'.tr, style: context.font20),
            SizedBox(height: 8.sp),
            Text(
              'your_feedback_will_help_us_improve_our_service_for_you'.tr,
              style: context.font14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.sp),
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
                      Iconsax.star_copy,
                      size: 40.sp,
                      color: i <= _rating ? Colors.orange : context.theme.disabledColor,
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
                    border: OutlineInputBorder(borderRadius: AppRadius.circular16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.circular16,
                      borderSide: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  maxLines: 3,
                  style: context.font14,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 32.sp),
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

  void _submitReview() {
    if (_rating > 3) {
      launchUrlString(AppConstants.appLink, mode: LaunchMode.externalApplication);
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
