import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:matrix_ai/helper/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/primary_button.dart';
import '../../../controller/subscription_controller.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/colors.dart';
import '../../../utils/style.dart';
import 'widgets/purchase_item.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 0;
  List<String> get benefits => [
        'No Ads',
        'Unlimited Time',
        'Access to all servers',
        'Ultra-fast connection',
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: GetBuilder<SubscriptionController>(builder: (con) {
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 16.sp),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: pop,
                        visualDensity: VisualDensity(horizontal: -4),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    Hero(
                      tag: 'crown',
                      child: LottieBuilder.asset(
                        "assets/animations/crown_pro.json",
                        width: 150.sp,
                      ),
                    ),
                    Text(
                      'Upgrade to ${AppConstants.APP_NAME} Pro',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // benefits
                    GridView.builder(
                      padding: EdgeInsets.only(top: 32.sp),
                      shrinkWrap: true,
                      itemCount: benefits.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.sp,
                        mainAxisSpacing: 8.sp,
                        childAspectRatio: 10.sp,
                      ),
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.sp),
                            Text(
                              benefits[index],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      },
                    ),
                    // subscription list
                    ListView.separated(
                      padding: EdgeInsets.only(top: 32.sp),
                      itemCount: con.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.sp),
                      itemBuilder: (context, index) {
                        final item = con.products[index];
                        return PurchaseItem(
                          item: item,
                          selected: _selectedIndex == index,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),

                    //
                    Padding(
                      padding: EdgeInsets.only(top: 32.sp),
                      child: RichText(
                        text: TextSpan(
                          text:
                              'This subscription is auto-renewable, will be re- activated at the end of selected period and can be cancelled at any time. ',
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: 'Cancel Subscription',
                              style: const TextStyle(
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  final url = Uri.parse(
                                      AppConstants.cancelSubscriptionUrl);
                                  launchUrl(url);
                                },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: () {
                    con.buyProduct(con.products[_selectedIndex]);
                  },
                ),
              ),
              SizedBox(height: 16.sp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.sp),
                child: RichText(
                  text: TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final url =
                                Uri.parse(AppConstants.privacyPolicyUrl);
                            launchUrl(url);
                          },
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Google Terms of Service',
                        style: const TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final url =
                                Uri.parse(AppConstants.termsAndConditionsUrl);
                            launchUrl(url);
                          },
                      ),
                      const TextSpan(
                          text: ' which describes how the data is handled.'),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
