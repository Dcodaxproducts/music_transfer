import 'package:matrix_ai/data/api/together_ai_error.dart';
import 'package:matrix_ai/imports.dart';

showTogetherAiErrorDialog(TogetherAIError error) {
  return showDialog(
    context: Get.context!,
    builder: (context) {
      return TogetherAiErrorDialog(error: error);
    },
  );
}

class TogetherAiErrorDialog extends StatelessWidget {
  final TogetherAIError error;
  const TogetherAiErrorDialog({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.warning_2, color: Colors.red, size: 80.sp),
            SizedBox(height: spacingDefault),
            Text("Oops!", style: titleLarge(context)),
            SizedBox(height: spacingDefault),
            Text(error.message.tr, style: bodyMedium(context), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            SizedBox(
              width: 120.sp,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'OK',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
