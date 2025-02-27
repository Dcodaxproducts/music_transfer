import '../../../data/model/aspect_ratio.dart';
import '../../../../../imports.dart';
import '../../../../../core/widgets/network_image.dart';

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  const AspectRatioBox({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ratio.width.toDouble(),
      height: ratio.height.toDouble(),
      child: ClipRRect(
        borderRadius: borderRadiusDefault,
        child: const CustomNetworkImage(url: 'https://picsum.photos/seed/4:3/200/300'),
      ),
    );
  }
}
