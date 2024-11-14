import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:matrix_ai/controller/models_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import 'package:matrix_ai/view/screens/set_theme/widgets/model_grid.dart';
import '../../../data/model/response/model.dart';
import '../../../helper/navigation.dart';
import '../../base/tab_button.dart';
import '../dashboard/widgets/glassbox_curve.dart';

class SetThemeScreen extends StatefulWidget {
  const SetThemeScreen({super.key});

  @override
  State<SetThemeScreen> createState() => _SetThemeScreenState();
}

class _SetThemeScreenState extends State<SetThemeScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  _changeTab(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32.sp),
      padding: pagePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // cancel button,
              const IconButton(
                onPressed: pop,
                icon: Icon(Icons.close),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              ),
              Text(
                'Set Theme',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'Done',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: primaryColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.sp),
            child: GlassBoxCurve(
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryTabButton(
                      text: 'AI Models',
                      selected: currentIndex == 0,
                      onPressed: () => _changeTab(0),
                      radiusLeft: 40.sp,
                      radiusRight: 0.sp,
                    ),
                  ),
                  Expanded(
                    child: PrimaryTabButton(
                      text: 'Favourites',
                      selected: currentIndex == 1,
                      onPressed: () => _changeTab(1),
                      radiusLeft: 0.sp,
                      radiusRight: 40.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<ModelsController>(builder: (modelsController) {
            final List<Model> models = modelsController.models;
            final List<Model> favoriteModels = modelsController.models
                .where((model) =>
                    modelsController.favoriteModels.contains(model.id))
                .toList();
            return Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  ModelsGrid(models: models),
                  ModelsGrid(models: favoriteModels),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
