import 'package:cached_network_image/cached_network_image.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/models_lab_response.dart';
import '../../../../../../imports.dart';
import '../../../../../../core/widgets/network_image.dart';
import '../../../../../../core/widgets/view_image.dart';
import '../../controller/image_generation_result_controller.dart';
import 'prompt_edit.dart';
import 'prompt_report.dart';

class PromptImageWidget extends StatefulWidget {
  final ImageGenerationResult response;
  const PromptImageWidget({super.key, required this.response});

  @override
  State<PromptImageWidget> createState() => PromptImageWidgetState();
}

class PromptImageWidgetState extends State<PromptImageWidget> {
  List<String> allOutputs = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final double outputSize = 100.sp;
  ImageGenerationResultController controller = ImageGenerationResultController.find;

  @override
  void initState() {
    _getLinkedResponses();

    super.initState();
  }

  void _getLinkedResponses() {
    allOutputs.clear();
    allOutputs.addAll(widget.response.output);
    if (widget.response.linkedResponses?.isNotEmpty ?? false) {
      for (int linkedId in widget.response.linkedResponses ?? []) {
        ImageGenerationResult? linkedResponse = controller.getResponseById(linkedId);
        if (linkedResponse?.output.isNotEmpty ?? false) {
          allOutputs.addAll(linkedResponse?.output ?? []);
        }
      }
    }
    _getInitialUrl();
  }

  void _getInitialUrl() {
    final result = widget.response;
    if (result.output.isEmpty) {
      controller.imageUrl = (result.futureLinks.isNotEmpty) ? result.futureLinks.first : '';
    } else {
      controller.imageUrl = result.output.first;
    }
  }

  void _selectImage(int index) {
    _currentIndex.value = index;
    controller.imageUrl = allOutputs[index];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationResultController>(
      builder: (controller) {
        String url = controller.imageUrl ?? '';
        return Column(
          children: [
            InkWell(
              onTap: () => launchScreen(ViewImage(url)),
              child: AspectRatio(
                aspectRatio: widget.response.meta.w / widget.response.meta.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Display the image
                    CustomNetworkImage(url: url, errorLoading: true),

                    const BackButton(),
                    const PromptEditButton(),
                    const PromptReportButton(),
                  ],
                ),
              ),
            ),
            Container(
              padding: AppPadding.padding12,
              child: SizedBox(
                height: outputSize,
                child: ValueListenableBuilder(
                  valueListenable: _currentIndex,
                  builder: (context, value, child) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: allOutputs.length,
                      separatorBuilder: (context, index) => SizedBox(width: 16.sp),
                      itemBuilder: (context, index) {
                        bool isSelected = _currentIndex.value == index;
                        return InkWell(
                          onTap: () => _selectImage(index),
                          borderRadius: AppRadius.circular8,
                          child: Stack(
                            children: [
                              Container(
                                width: (outputSize + 10).sp,
                                decoration: BoxDecoration(
                                  color: context.theme.cardColor,
                                  borderRadius: AppRadius.circular8,
                                ),
                                child: ClipRRect(
                                  borderRadius: AppRadius.circular8,
                                  child: CachedNetworkImage(
                                    imageUrl: allOutputs[index],
                                    width: (outputSize + 10).sp,
                                    height: outputSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: outputSize + 10.sp,
                                  height: outputSize,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: AppRadius.circular8,
                                  ),
                                  child: Icon(Icons.check_circle_rounded, size: 16.sp, color: Colors.white),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10.sp,
      left: 10,
      child: InkWell(
        onTap: pop,
        child: Container(
          padding: EdgeInsets.all(8.sp),
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Icon(Icons.arrow_back, size: 22.sp, color: Colors.black),
        ),
      ),
    );
  }
}
