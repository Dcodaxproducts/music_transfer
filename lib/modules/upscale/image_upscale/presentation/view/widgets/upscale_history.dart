import 'package:pixart_app/imports.dart';
import 'package:pixart_app/core/widgets/network_image.dart';
import 'package:pixart_app/modules/upscale/image_upscale/presentation/controller/image_upscale_controller.dart';
import 'package:pixart_app/core/widgets/confirmation_dialog.dart';
import '../../../../../bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import '../../../../../../features/tools/data/model/tools.dart';
import '../../../data/model/upscale_response.dart';
import '../../../../../../core/widgets/queue_countdown.dart';
import '../image_result_screen.dart';
import 'countdown_widget.dart';

class UpscaleHistoryList extends StatelessWidget {
  final ToolModel tool;
  const UpscaleHistoryList({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageUpscaleController>(
      builder: (upscaleController) {
        return GetBuilder<BackgroundRemoverController>(
          builder: (backgroundController) {
            List<UpscaleResponse> history = [];
            if (tool.backgroundRemover != null) {
              history = backgroundController.backgroundRemovalHistory;
            } else {
              history = upscaleController.upscaleHistory;
            }
            history.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            return Visibility(
              visible: history.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.sp),
                  Text('recent'.tr, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.sp),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 16.sp),
                    itemCount: history.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.sp,
                      crossAxisSpacing: 16.sp,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      return HistoryItem(response: history[index]);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class HistoryItem extends StatelessWidget {
  final UpscaleResponse response;
  const HistoryItem({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (response.status == 'success') {
          launchScreen(ImageResultScreen(response: response));
        }
      },
      borderRadius: AppRadius.circular8,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: AppRadius.circular8),
        child: ClipRRect(
          borderRadius: AppRadius.circular8,
          child: UpscaleImageCountdownWidget(
            response: response,
            builder: (context, isCompleted, imageUrl, remainingTime, isRetrying) {
              return isCompleted
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomNetworkImage(url: imageUrl, errorLoading: true),
                        Positioned(
                          top: 10.sp,
                          right: 10.sp,
                          child: GestureDetector(
                            onTap: _deleteResult,
                            child: Container(
                              padding: EdgeInsets.all(5.sp),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Icon(Iconsax.trash, size: 15.sp, color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    )
                  : QueueCountdown(remainingTime: remainingTime, isRetrying: isRetrying, padding: false);
            },
          ),
        ),
      ),
    );
  }

  void _deleteResult() {
    showConfirmationDialog(
      title: 'Delete Result',
      subtitle: "Are you sure you want to result this result?",
      actionText: 'Delete',
      onAccept: () {
        pop();
        if (response.isBackgroundRemover) {
          BackgroundRemoverController.find.removeBackgroundRemovalHistory(response);
        } else {
          ImageUpscaleController.find.removeUpscaleHistory(response);
        }
      },
    );
  }
}
