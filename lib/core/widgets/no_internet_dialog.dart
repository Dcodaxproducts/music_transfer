import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pixart_app/imports.dart';

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
          SizedBox(height: 16.sp),
          Text(
            'no_internet'.tr,
            style: context.font16.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.sp),
          Text(
            'no_internet_message'.tr,
            textAlign: TextAlign.center,
            style: context.font14,
          ),
          SizedBox(height: 24.sp),
          SizedBox(
            width: 200.sp,
            child: PrimaryOutlineButton(
              onPressed: () async {},
              text: 'retry'.tr,
            ),
          ),
          SizedBox(height: 24.sp),
        ],
      ),
    );
  }
}

Future<bool> isConnected() async {
  List<ConnectivityResult> connectivityResult = await Connectivity()
      .checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
}
