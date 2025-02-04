import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import '../../../../imports.dart';
import '../../../base/common/network_image.dart';
import '../../../base/view_image.dart';
import 'prompt_edit.dart';
import 'prompt_report.dart';

class PromptImageWidget extends StatefulWidget {
  final PromptResponse response;
  const PromptImageWidget({super.key, required this.response});

  @override
  State<PromptImageWidget> createState() => PromptImageWidgetState();
}

class PromptImageWidgetState extends State<PromptImageWidget> {
  List<String> allOutputs = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  final double outputSize = 100.sp;

  @override
  void initState() {
    _getLinkedResponses();

    super.initState();
  }

  _getLinkedResponses() {
    allOutputs.clear();
    allOutputs.addAll(widget.response.output);
    if (widget.response.linkedResponses?.isNotEmpty ?? false) {
      for (int linkedId in widget.response.linkedResponses ?? []) {
        PromptResponse? linkedResponse = ImageGenerationController.find.getResponseById(linkedId);
        if (linkedResponse?.output.isNotEmpty ?? false) {
          allOutputs.addAll(linkedResponse?.output ?? []);
        }
      }
    }
    _getInitialUrl();
  }

  _getInitialUrl() {
    final result = widget.response;
    if (result.output.isEmpty) {
      ImageGenerationController.find.imageUrl =
          (result.futureLinks.isNotEmpty) ? result.futureLinks.first : '';
    } else {
      ImageGenerationController.find.imageUrl = result.output.first;
    }
  }

  _selectImage(int index) {
    _currentIndex.value = index;
    ImageGenerationController.find.imageUrl = allOutputs[index];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenerationController>(
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
                    // image
                    Hero(
                      tag: url,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(spacingDefault)),
                        child: CustomNetworkImage(url: url, errorLoading: true),
                      ),
                    ),

                    const BackButton(),
                    const PromptEditButton(),
                    const PromptReportButton(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: paddingDefault,
              child: SizedBox(
                height: outputSize,
                child: ValueListenableBuilder(
                    valueListenable: _currentIndex,
                    builder: (context, value, child) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: allOutputs.length,
                        separatorBuilder: (context, index) => SizedBox(width: spacingDefault),
                        itemBuilder: (context, index) {
                          bool isSelected = _currentIndex.value == index;
                          return InkWell(
                            onTap: () => _selectImage(index),
                            borderRadius: borderRadiusSmall,
                            child: Stack(
                              children: [
                                Container(
                                  width: (outputSize + 10).sp,
                                  decoration: BoxDecoration(
                                    color: context.theme.cardColor,
                                    borderRadius: borderRadiusSmall,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: borderRadiusSmall,
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
                                      borderRadius: borderRadiusSmall,
                                    ),
                                    child: Icon(
                                      Icons.check_circle_rounded,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
            )
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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.arrow_back,
            size: 22.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
