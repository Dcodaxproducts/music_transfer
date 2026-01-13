import 'package:pixart_app/core/widgets/shimmer.dart';
import 'package:pixart_app/features/tools/data/model/tools.dart';
import '../../../../core/widgets/primary_image_grid.dart';
import '../../../../imports.dart';
import '../widgets/tools_card.dart';

class CategoryScreen extends StatelessWidget {
  final List<Tool> tools;
  final String category;
  const CategoryScreen({super.key, required this.tools, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton(), title: Text(category.tr)),
      body: PrimaryImageGrid(
        childAspectRatio: 0.75,
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final Tool tool = tools[index];
          return ToolCard(tool: tool);
        },
      ),
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
