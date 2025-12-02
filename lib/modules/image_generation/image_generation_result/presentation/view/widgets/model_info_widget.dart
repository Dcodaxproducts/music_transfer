import 'package:cached_network_image/cached_network_image.dart';
import 'package:pixart_app/imports.dart';
import 'package:view_more/view_more.dart';
import '../../../../home/data/model/models_lab_response.dart';
import '../../../../models/data/model/model.dart';
import '../../../../../../core/helper/date_converter.dart';

class ModelInfoWidget extends StatelessWidget {
  final ImageGenerationResult response;
  const ModelInfoWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    Model model = response.model!;
    return Column(
      children: [
        Row(
          children: [
            // model image
            CircleAvatar(radius: 20.sp, backgroundImage: CachedNetworkImageProvider(model.image)),
            SizedBox(width: 12.sp),
            // model name,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(model.name, style: context.font12.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 2.sp),
                  Text(
                    DateConverter.convertDate(response.createdAt!),
                    style: context.font10.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.sp),
        ViewMore(
          response.meta.prompt.trim(),
          trimLines: 2,
          trimMode: Trimer.line,
          textAlign: TextAlign.start,
          style: context.font12.copyWith(color: Theme.of(context).hintColor),
          trimExpandedText: ' View Less',
          trimCollapsedText: ' View More',
        ),
      ],
    );
  }
}
