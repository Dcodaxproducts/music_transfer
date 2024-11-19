import 'package:matrix_ai/utils/app_constants.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class AppReview {
  static final InAppReview inAppReview = InAppReview.instance;

  static showReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      launchUrl(
        Uri.parse(AppConstants.ANDROID_APP_URL),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
