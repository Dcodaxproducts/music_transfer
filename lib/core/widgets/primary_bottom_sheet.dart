import '../../imports.dart';

class PrimaryBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const PrimaryBottomSheet({super.key, required this.title, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
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
                Text(title, style: context.font16.copyWith(fontWeight: FontWeight.w600)),

                // close button
                PrimaryCloseButton(),
              ],
            ),
            SizedBox(height: 24.sp),
            child,
            SafeArea(child: SizedBox(height: 16.sp)),
          ],
        ),
      ),
    );
  }
}
