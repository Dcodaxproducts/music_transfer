import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../common/primary_button.dart';
import '../../../controller/subscription_controller.dart';
import '../../../data/model/subscription_item.dart';
import '../../../helper/navigation.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import 'widgets/purchase_item.dart';

showPremiumSheet() => showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SubscriptionScreen(),
    );

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPackage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              Images.subscriptionBg,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.35),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          // add black gradient to the background (it should cover half bottom screen),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
                stops: [0.3, 1],
              ),
            ),
          ),
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 70.sp,
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: Text(
          //       'Ad-free experience'.tr,
          //       style: Theme.of(context).textTheme.displayLarge?.copyWith(
          //             color: Colors.white,
          //             fontSize: 24.sp,
          //             fontWeight: FontWeight.bold,
          //           ),
          //     ),
          //   ),
          // ),
          GetBuilder<SubscriptionController>(
            builder: (subscription) {
              return Padding(
                padding: pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.sp),
                      itemBuilder: (context, index) {
                        return SubscriptionPackageWidget(
                          selected: _selectedPackage == index,
                          item: getSubscriptionItems(index),
                          onTap: () {
                            setState(() {
                              _selectedPackage = index;
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 32.sp),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: 'continue'.tr,
                        onPressed: () {
                          subscription.buyProduct(
                            subscription.products[_selectedPackage],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 12.sp),
                    Center(
                      child: Wrap(
                        spacing: 8.sp,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          LinkButton(
                            text: 'privacy_policy'.tr,
                            onTap: () {
                              launchUrlString(AppConstants.privacyPolicyUrl);
                            },
                          ),
                          LinkButton(
                            text: 'terms_of_service'.tr,
                            onTap: () {
                              launchUrlString(AppConstants.privacyPolicyUrl);
                            },
                          ),
                          LinkButton(
                            text: 'restore'.tr,
                            onTap: subscription.restorePurchase,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 40.sp,
            right: 16.sp,
            child: const CloseButton(),
          ),
        ],
      ),
    );
  }

  SubscriptionItem getSubscriptionItems(int index) {
    String title = '';
    String subtitle = '';
    String price = '';
    String promotionalText = '';

    if (index == 2) {
      title = 'weekly'.tr;
      subtitle = 'test_ad_free_for_a_week'.tr;
      price = "\$6.99";
      promotionalText = '';
    } else if (index == 1) {
      title = 'monthly'.tr;
      subtitle =
          '${'only'.tr} \$5.99/ ${'month'.tr}, ${'enjoy_a_month_of_no_ads'.tr}!';
      price = '\$23.99';
      promotionalText = '14% ${'off'.tr.toUpperCase()}';
    } else {
      title = 'yearly'.tr;
      subtitle =
          '${'only'.tr} \$7.50/ ${'year'.tr}, ${'enjoy_a_year_of_no_ads'.tr}!';
      price = '\$84.99';
      promotionalText = '75% ${'off'.tr.toUpperCase()}';
    }
    return SubscriptionItem(
      title: title,
      subtitle: subtitle,
      price: price,
      promotionText: promotionalText,
    );
  }
}

class LinkButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const LinkButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: primaryColor),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: pop,
      child: Container(
        padding: EdgeInsets.all(5.sp),
        child: Icon(
          Icons.close,
          color: Colors.grey,
          size: 20.sp,
        ),
      ),
    );
  }
}
