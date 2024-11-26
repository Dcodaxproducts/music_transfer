import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/primary_button.dart';
import '../../../controller/settings_controller.dart';
import '../../../controller/subscription_controller.dart';
import '../../../data/model/subscription_item.dart';
import '../../../helper/navigation.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/style.dart';
import '../html/html_screen.dart';
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
  SubscriptionItem get _selectedItem => getSubscriptionItems(_selectedPackage);
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
              height: context.height * 0.695,
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
                        SubscriptionItem item = getSubscriptionItems(index);
                        return SubscriptionPackageWidget(
                          selected: _selectedPackage == index,
                          item: item,
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
                          if (_selectedItem.product == null) return;
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
                            onTap: () => launchScreen(
                              HtmlScreen(
                                  html: SettingsController
                                      .find.settingModel.privacyPolicy),
                            ),
                          ),
                          LinkButton(
                            text: 'terms_of_service'.tr,
                            onTap: () => launchScreen(
                              HtmlScreen(
                                  html: SettingsController
                                      .find.settingModel.termsAndConditions),
                            ),
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
          // show button after 2 seconds with tween animation builder
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 5),
            builder: (context, double value, child) {
              return Positioned(
                top: 40.sp,
                left: 16.sp,
                child: Opacity(
                  opacity: value,
                  child: const CloseButton(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  SubscriptionItem getSubscriptionItems(int index) {
    List<IAPItem> products = SubscriptionController.find.products;

    if (index == 0) {
      return SubscriptionItem.yearlySubscription(products);
    } else if (index == 1) {
      return SubscriptionItem.monthlySubscription(products);
    } else {
      return SubscriptionItem.weeklySubscription(products);
    }
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
