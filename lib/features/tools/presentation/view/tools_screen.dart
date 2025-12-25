import 'package:pixart_app/core/widgets/shimmer.dart';
import 'package:pixart_app/features/tools/data/model/tools.dart';
import '../../../../imports.dart';
import '../controller/tools_controller.dart';
import '../widgets/tools_card.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  @override
  void initState() {
    ToolsController.find.getTools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const ToolsShimmer();
        }
        return GridView.builder(
          padding: AppPadding.screenPadding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.sp,
            crossAxisSpacing: 16.sp,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.tools.length,
          itemBuilder: (context, index) {
            final ToolsNew tool = controller.tools[index];
            return ToolCard(tool: tool);
          },
        );
      },
    );
  }
}

class ToolsShimmer extends StatelessWidget {
  const ToolsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppPadding.screenPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.sp,
        crossAxisSpacing: 16.sp,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return CustomShimmer(
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: AppRadius.circular8),
          ),
        );
      },
    );
  }
}
