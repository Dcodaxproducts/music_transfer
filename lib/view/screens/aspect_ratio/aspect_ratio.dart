import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/network_image.dart';
import '../../../controller/settings_controller.dart';
import '../../../data/model/body/aspect_ratio.dart';
import '../../../helper/navigation.dart';
import '../../../utils/colors.dart';
import '../../../utils/style.dart';

class AspectRatioScreen extends StatelessWidget {
  const AspectRatioScreen({super.key});

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
                'Aspect Ratio',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  SetttingsController con = SetttingsController.find;
                  con.configModel = con.configModel.copyWith(
                      negativePrompt: con.negativePromptController.text.trim());
                  pop();
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
          Expanded(
            child: GetBuilder<SetttingsController>(builder: (con) {
              return GridView.builder(
                itemCount: aspectRatios.length,
                padding: EdgeInsets.only(top: 16.sp),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final ratio = aspectRatios[index];
                  bool selected = con.configModel.aspectRatio == ratio.id;
                  return InkWell(
                    onTap: () {
                      con.configModel =
                          con.configModel.copyWith(aspectRatio: ratio.id);
                      pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: pagePadding,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected
                              ? primaryColor
                              : Theme.of(context).dividerColor,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: borderRadius,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(
                            child: AspectRatioBox(ratio: ratio),
                          ),
                          FittedBox(
                            child: Container(
                              width: ratio.width.toDouble(),
                              height: ratio.height.toDouble(),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: borderRadius,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${ratio.width} x ${ratio.height}'
                              '\n'
                              '(${ratio.aspectRatio})',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  const AspectRatioBox({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ratio.width.toDouble(),
      height: ratio.height.toDouble(),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: const CustomNetworkImage(
            url: 'https://picsum.photos/seed/4:3/200/300'),
      ),
    );
  }
}
