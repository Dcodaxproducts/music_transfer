import '../../imports.dart';

Future showConfirmationDialog({
  required String title,
  required String subtitle,
  required String actionText,
  required Function() onAccept,
}) {
  return showDialog(
    context: Get.context!,
    builder: (context) =>
        ConfirmationDialog(title: title, subtitle: subtitle, actionText: actionText, onAccept: onAccept),
  );
}

class ConfirmationDialog extends StatelessWidget {
  final String title, subtitle, actionText;
  final Function() onAccept;
  const ConfirmationDialog({
    required this.title,
    required this.subtitle,
    required this.actionText,
    required this.onAccept,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title.tr, style: context.font16.copyWith(fontWeight: FontWeight.w700)),
            Divider(height: 24.sp),
            Text(subtitle.tr, textAlign: TextAlign.center, style: context.font14),
            SizedBox(height: 24.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: PrimaryOutlineButton(
                    text: 'cancel'.tr,
                    onPressed: pop,
                    textColor: context.textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: PrimaryButton(text: actionText, onPressed: onAccept),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showErrorDialog() {
  return Get.dialog(const ErrorDialog());
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: AppPadding.padding16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.info_circle, size: 70.sp, color: Colors.red),
            SizedBox(height: 16.sp),
            Text('Oops', style: context.font24.copyWith(fontWeight: FontWeight.w500)),
            SizedBox(height: 8.sp),
            Text('engine_overloaded'.tr, textAlign: TextAlign.center, style: context.font16),
            SizedBox(height: 24.sp),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(text: 'Ok'.tr, onPressed: Get.back, color: context.theme.canvasColor),
            ),
          ],
        ),
      ),
    );
  }
}
