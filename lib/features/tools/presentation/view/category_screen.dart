import 'package:pixart_app/features/tools/data/model/tools.dart';
import '../../../../imports.dart';
import '../widgets/tools_card.dart';

class CategoryScreen extends StatelessWidget {
  final List<Tool> tools;
  final String category;
  const CategoryScreen({super.key, required this.tools, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            leading: PrimaryBackButton(),
            title: Row(
              children: [
                Icon(Iconsax.element_4, color: context.font26.color),
                SizedBox(width: 8.sp),
                Text('${AppConstants.appName} ${'apps'.tr}', style: context.font26),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(40.sp),
              child: Padding(
                padding: EdgeInsets.all(16.sp).copyWith(bottom: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$category app now a click away",
                    style: context.font14.copyWith(color: context.theme.hintColor),
                  ),
                ),
              ),
            ),
            floating: false,
            pinned: true,
            snap: false,
          ),
          SliverPadding(
            padding: AppPadding.padding16,
            sliver: SliverGrid.builder(
              itemCount: tools.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final Tool tool = tools[index];
                return ToolCard(tool: tool);
              },
            ),
          ),
        ],
      ),
    );
  }
}
