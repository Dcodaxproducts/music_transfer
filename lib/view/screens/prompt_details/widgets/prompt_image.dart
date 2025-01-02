import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import '../../../../imports.dart';
import '../../../base/common/network_image.dart';
import '../../../base/view_image.dart';
import 'prompt_edit.dart';
import 'prompt_report.dart';

class PromptImageWidget extends StatelessWidget {
  final PromptResponse response;
  const PromptImageWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final result = response;
    int width = result.meta.w;
    int height = result.meta.h;
    String url = '';
    if (result.output.isEmpty) {
      url = (result.futureLinks.isNotEmpty) ? result.futureLinks.first : '';
    } else {
      url = result.output.first;
    }
    return GetBuilder<ImageGenerationController>(builder: (controller) {
      return InkWell(
        onTap: () => launchScreen(ViewImage(url)),
        child: AspectRatio(
          aspectRatio: width / height,
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
      );
    });
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
