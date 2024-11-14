import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/common/network_image.dart';
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
      return MasonryGridView.builder(
        itemCount: inspirations.length,
        padding: EdgeInsets.all(8.sp).copyWith(bottom: 100.sp),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2),
        mainAxisSpacing: 8.sp,
        crossAxisSpacing: 8.sp,
        itemBuilder: (context, index) => InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (_) => InspirationDialog(inspiration: inspirations[index]),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: CustomNetworkImage(
                  url: inspirations[index].image,
                  color: Colors.black.withOpacity(0.15),
                ),
              ),
              Positioned(
                bottom: 8.sp,
                right: 8.sp,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: Text(
                    'try_now'.tr.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
