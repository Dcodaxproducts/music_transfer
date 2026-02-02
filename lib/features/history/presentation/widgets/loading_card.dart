import '../../../../imports.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: AppRadius.circular12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.sp,
            height: 20.sp,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(context.font12.color ?? primaryLight),
              strokeWidth: 2.sp,
            ),
          ),
          SizedBox(height: 16.sp),
          Text(
            'generating_may_take_1_min'.tr,
            style: context.font12.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
