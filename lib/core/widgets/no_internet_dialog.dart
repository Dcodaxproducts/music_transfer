import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:matrix_ai/imports.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // full screen dialog
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.sp),
      width: double.infinity,
      height: double.infinity,
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.noInternet, width: 300.sp),
          SizedBox(height: spacingDefault),
          Text(
            'no_internet'.tr,
            style: bodyLarge(context).copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: spacingSmall),
          Text('no_internet_message'.tr, textAlign: TextAlign.center, style: bodyMedium(context)),
          SizedBox(height: spacingLarge),
          SizedBox(
            width: 200.sp,
            child: PrimaryOutlineButton(
              onPressed: () async {},
              text: 'retry'.tr,
            ),
          ),
          SizedBox(height: spacingLarge),
        ],
      ),
    );
  }
}

Future<bool> isConnected() async {
  List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
}
