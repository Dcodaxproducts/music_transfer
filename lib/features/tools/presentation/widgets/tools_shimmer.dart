import '../../../../core/widgets/shimmer.dart';
import '../../../../imports.dart';

class ToolsShimmer extends StatelessWidget {
  const ToolsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppPadding.padding12,
      children: List.generate(3, (categoryIndex) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomShimmer(
                  child: Container(
                    width: 120.sp,
                    height: 20.sp,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.circular8),
                  ),
                ),
                CustomShimmer(
                  child: Container(
                    width: 60.sp,
                    height: 16.sp,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.circular8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.sp),

            // Horizontal scrolling tools shimmer
            SizedBox(
              height: 240.sp,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => SizedBox(width: 8.sp),
                itemBuilder: (_, index) {
                  return CustomShimmer(
                    child: Container(
                      width: 170.sp,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.circular8),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.sp),
          ],
        );
      }),
    );
  }
}