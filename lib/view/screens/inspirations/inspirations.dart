import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/view/base/common/network_image.dart';
import 'package:matrix_ai/controller/ads_controller.dart';
import 'package:matrix_ai/controller/inspiration_controller.dart';
import 'package:matrix_ai/data/model/response/inspiration.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import 'widgets/inspiration_dialog.dart';

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InspirationController>(builder: (inspirationController) {
      final List<Inspiration> inspirations = inspirationController.inspirations;
      return Column(
        children: [
          if (inspirationController.inspirations.isNotEmpty) AdsController.find.showInspirationScreenAd(),
          Expanded(
            child: MasonryGridView.builder(
              itemCount: inspirations.length,
              padding: paddingSmall.copyWith(bottom: 100.sp),
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.width < 600 ? 2 : 3,
              ),
              mainAxisSpacing: spacingSmall,
              crossAxisSpacing: spacingSmall,
              itemBuilder: (context, index) => InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => InspirationDialog(inspiration: inspirations[index]),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: borderRadiusDefault,
                      child: CustomNetworkImage(
                        url: inspirations[index].image,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),
                    Positioned(
                      bottom: spacingSmall,
                      right: spacingSmall,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: spacingExtraSmall, horizontal: spacingSmall),
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7), borderRadius: borderRadiusDefault),
                        child: Text(
                          'try_now'.tr.toUpperCase(),
                          style: labelLarge(context).copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
