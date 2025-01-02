import 'package:cached_network_image/cached_network_image.dart';
import 'package:matrix_ai/imports.dart';
import 'package:view_more/view_more.dart';
import '../../../../data/model/response/models_lab_response.dart';
import '../../../../data/model/response/model.dart';
import '../../../../helper/date_converter.dart';

class ModelInfoWidget extends StatelessWidget {
  final PromptResponse response;
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
            SizedBox(width: spacingMedium),
            // model name,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    DateConverter.convertDate(response.createdAt!),
                    style: labelLarge(context).copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: spacingMedium),
        ViewMore(
          response.meta.prompt.trim(),
          trimLines: 2,
          trimMode: Trimer.line,
          textAlign: TextAlign.start,
          style: bodySmall(context).copyWith(color: Theme.of(context).hintColor),
          trimExpandedText: ' View Less',
          trimCollapsedText: ' View More',
        ),
      ],
    );
  }
}
