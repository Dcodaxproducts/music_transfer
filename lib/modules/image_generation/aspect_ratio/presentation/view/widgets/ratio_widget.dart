import '../../../data/model/aspect_ratio.dart';
import '../../../../../../imports.dart';

class AspectRatioBox extends StatelessWidget {
  final AspectRatioModel ratio;
  const AspectRatioBox({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ratio.width.toDouble(),
      height: ratio.height.toDouble(),
      child: ClipRRect(
        borderRadius: AppRadius.circular16,
        child: const PrimaryNetworkImage(url: 'https://picsum.photos/seed/4:3/200/300'),
      ),
    );
  }
}
