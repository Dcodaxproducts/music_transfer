import 'package:pixart_app/core/widgets/primary_image_grid.dart';
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
        return PrimaryImageGrid(
          childAspectRatio: 0.75,
          itemCount: controller.tools.length,
          itemBuilder: (context, index) {
            final Tools tool = controller.tools[index];
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
      padding: AppPadding.padding12,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.width > 600 ? 4 : 2,
        mainAxisSpacing: 8.sp,
        crossAxisSpacing: 8.sp,
        childAspectRatio: 0.75,
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
