import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/image_upscale/presentation/controller/image_upscale_controller.dart';
import '../../data/model/upscale_result.dart';
import 'image_result_screen.dart';

class UpscaleHistoryList extends StatelessWidget {
  const UpscaleHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageUpscaleController>(
      builder: (upscaleController) {
        List<UpscaleResult> history = [];
        history = upscaleController.history;
        history.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return Visibility(
          visible: history.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.sp),
              Text(
                ToolModel.upscaleImageTool.name.tr,
                style: context.font14.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.sp),
              SizedBox(
                height: 200.sp,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: history.length,
                  separatorBuilder: (context, index) => SizedBox(width: 16.sp),
                  itemBuilder: (context, index) {
                    return HistoryItem(response: history[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HistoryItem extends StatelessWidget {
  final UpscaleResult response;
  const HistoryItem({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = AppRadius.circular8;
    return SizedBox(
      width: 150.sp,
      child: InkWell(
        onTap: () => launchScreen(UpscaleResultScreen(response: response)),
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: borderRadius),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: PrimaryNetworkImage(url: response.image),
          ),
        ),
      ),
    );
  }
}
