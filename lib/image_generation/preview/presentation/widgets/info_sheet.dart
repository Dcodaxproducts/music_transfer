import 'package:flutter/services.dart';
import 'package:pixart_app/image_generation/home/data/model/image_generation.dart';
import 'package:view_more/view_more.dart';
import '../../../../core/helper/date_converter.dart';
import '../../../../imports.dart';
import '../../../home/presentation/controller/image_generation_controller.dart';

class ResultInfoSheet extends StatelessWidget {
  const ResultInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageGenerationResult? result = ImageGenController.find.result;
    return Visibility(
      visible: result != null,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.bottomSheetTheme.backgroundColor,
          borderRadius: AppRadius.top(16),
        ),
        child: Stack(
          children: [
            Positioned(right: 16.sp, top: 16.sp, child: PrimaryCloseButton()),
            Padding(
              padding: AppPadding.padding16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Info', style: context.font16.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 12.sp),
                  Row(
                    children: [
                      // model image
                      CircleAvatar(
                        radius: 20.sp,
                        backgroundImage: CachedNetworkImageProvider(result!.meta.model.image),
                      ),
                      SizedBox(width: 12.sp),
                      // model name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.meta.model.name,
                              style: context.font12.copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 2.sp),
                            Text(
                              DateConverter.convertDate(result.createdAt),
                              style: context.font10.copyWith(color: Theme.of(context).hintColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.sp),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: result.meta.prompt.trim()));
                        },
                        child: Icon(Iconsax.copy, size: 16.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.sp),
                  ViewMore(
                    result.meta.prompt.trim(),
                    trimLines: 2,
                    trimMode: Trimer.line,
                    textAlign: TextAlign.start,
                    style: context.font12,
                    trimExpandedText: ' View Less',
                    trimCollapsedText: ' View More',
                  ),
                  SizedBox(height: 12.sp),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 16.sp),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.circular16,
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        '${result.meta.width} x ${result.meta.height}',
                        style: context.font12.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
