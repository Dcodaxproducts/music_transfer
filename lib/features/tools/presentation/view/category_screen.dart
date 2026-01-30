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
