import '../../imports.dart';

class PrimaryBottomSheet extends StatelessWidget {
  final String title;
  const PrimaryBottomSheet({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
      ),
      child: Padding(
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // back button
                SizedBox(width: 24.sp),

                // title
                Text('Settings', style: context.font16.copyWith(fontWeight: FontWeight.w600)),

                // close button
                PrimaryCloseButton(),
              ],
            ),
            SizedBox(height: 12.sp),
          ],
        ),
      ),
    );
  }
}
