import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/modules.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/primary_button.dart';
import '../../../controller/subscription_controller.dart';
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

List<String> _premiumFeatures = [
  'upscale_image',
  'face_fix',
  'models',
  'remove_ads',
  'image_quality',
  'denoise_steps',
];

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Images.background,
            fit: BoxFit.cover,
          ),
          GetBuilder<SubscriptionController>(
            builder: (subscription) {
              return SingleChildScrollView(
                child: Padding(
                  padding: pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 340),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _premiumFeatures.length,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              const Icon(
                                Iconsax.check,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _premiumFeatures[index].tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      for (int i = 0;
                          i < subscription.products.length;
                          i++) ...[
                        SubscriptionPackageWidget(
                          selected: _selectedPackage == i,
                          title: getText(subscription.products[i])['title'],
                          price: getText(subscription.products[i])['price'],
                          onTap: () {
                            setState(() {
                              _selectedPackage = i;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                      const SizedBox(height: 32),
                      PrimaryButton(
                        text: 'continue'.tr,
                        onPressed: () {
                          subscription.buyProduct(
                            subscription.products[_selectedPackage],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: RichText(
                            text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: '${'note'.tr}: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            TextSpan(
                              text:
                                  'these_subscriptions_can_be_cancelled_anytime_they_are_automatically_renewed_at_the_end_of_selected_period'
                                      .tr,
                            ),
                          ],
                        )),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: pagePadding,
                        decoration: BoxDecoration(
                          color: const Color(0xFF171819),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(radius)),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              'by_continuing_you_agree_to'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // privacy policy,
                                LinkButton(
                                  text: 'privacy_policy'.tr,
                                  url:
                                      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldo=0&ldt=privacynotice&ldl=en_GB',
                                ),

                                // cancel anytime,
                                LinkButton(
                                  text: 'terms_of_service'.tr,
                                  url:
                                      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldl=en_GB&ldo=0&ldt=buyertos',
                                ),

                                // privacy policy,
                                LinkButton(
                                  text: 'terms_of_service'.tr,
                                  url:
                                      'https://payments.google.com/payments/apis-secure/u/0/get_legal_document?ldo=0&ldt=buyertos&ldl=en_GB',
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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

  getText(IAPItem productDetails) {
    if (productDetails.productId == 'monthly_plan') {
      return {
        'title': 'monthly',
        "price": productDetails.localizedPrice,
      };
    } else if (productDetails.productId == 'weekly_plan') {
      return {
        'title': 'weekly',
        "price": productDetails.localizedPrice,
      };
    } else {
      return {
        'title': 'yearly',
        "price": productDetails.localizedPrice,
      };
    }
  }
}

class LinkButton extends StatelessWidget {
  final String text;
  final String url;
  const LinkButton({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => launchUrl(Uri.parse(url)),
      child: Text(
        text.tr,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: primaryColor,
              decorationColor: primaryColor,
              decoration: TextDecoration.underline,
            ),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          color: Colors.black,
          size: 20.sp,
        ),
      ),
    );
  }
}
