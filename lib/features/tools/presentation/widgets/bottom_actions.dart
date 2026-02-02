import '../../../../../imports.dart';
import '../controller/tools_controller.dart';

class ToolResultActions extends StatelessWidget {
  const ToolResultActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.sp,
        children: [ShareButton(url: ToolsController.find.result?.image ?? '')],
      ),
    );
  }
}
