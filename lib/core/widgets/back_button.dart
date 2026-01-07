import '../../imports.dart';

class PrimaryBackButton extends StatelessWidget {
  const PrimaryBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.padding8,
      child: InkWell(
        onTap: Get.back,
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(shape: BoxShape.circle, color: context.theme.cardColor),
          child: Icon(Icons.arrow_back, size: 22.sp, color: context.font14.color),
        ),
      ),
    );
  }
}

class PrimaryCloseButton extends StatelessWidget {
  final Function()? onTap;
  const PrimaryCloseButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? Get.back,
      borderRadius: AppRadius.circular32,
      child: Container(
        padding: AppPadding.padding8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: context.theme.canvasColor),
        child: Icon(Icons.close, size: 18.sp, color: context.font14.color),
      ),
    );
  }
}
