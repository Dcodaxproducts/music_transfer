import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/primary_button.dart';
import '../../utils/images.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // full screen dialog
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.sp),
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(Images.noInternet, width: 300.sp),
          SizedBox(height: 20.sp),
          Text(
            'no_internet'.tr,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.sp),
          Text(
            'no_internet_message'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200.sp,
            child: PrimaryOutlineButton(
              onPressed: () async {},
              text: 'retry'.tr,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

Future<bool> isConnected() async {
  List<ConnectivityResult> connectivityResult =
      await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
}
