import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixart_app/features/ads/presentation/controller/ads_controller.dart';
import 'package:pixart_app/modules/image_generation/inspirations/presentation/controller/inspiration_controller.dart';
import 'package:pixart_app/modules/image_generation/inspirations/data/model/inspiration.dart';
import '../../../../../imports.dart';
import 'inspiration_detail.dart';

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InspirationController>(
      builder: (inspirationController) {
        final List<Inspiration> inspirations = inspirationController.inspirations;
        return Column(
          children: [
            if (inspirationController.inspirations.isNotEmpty) AdsController.find.buildInspirationScreenAd(),
            Expanded(
              child: MasonryGridView.builder(
                itemCount: inspirations.length,
                padding: EdgeInsets.all(4.sp).copyWith(bottom: 100.sp),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.width < 600 ? 2 : 3,
                ),
                mainAxisSpacing: 4.sp,
                crossAxisSpacing: 4.sp,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => launchScreen(InspirationDetailScreen(inspiration: inspirations[index])),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.circular8,
                        child: PrimaryNetworkImage(url: inspirations[index].image),
                      ),
                      Positioned(
                        bottom: 8.sp,
                        right: 8.sp,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.7),
                            borderRadius: AppRadius.circular16,
                          ),
                          child: Text(
                            'try_now'.tr.toUpperCase(),
                            style: context.font10.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
