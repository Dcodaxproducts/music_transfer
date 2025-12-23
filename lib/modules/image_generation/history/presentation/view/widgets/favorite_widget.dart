import 'package:pixart_app/modules/image_generation/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import '../../../../../../imports.dart';

class FavoriteHistoryIcon extends StatelessWidget {
  final ImageGenerationResult response;
  final double positioned;
  const FavoriteHistoryIcon({
    super.key,
    required this.response,
    this.positioned = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: positioned.sp,
      right: positioned.sp,
      child: GestureDetector(
        onTap: () => HistoryController.find.toggleFavorite(response),
        child: Container(
          padding: EdgeInsets.all(5.sp),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            getIcon(),
            size: 15.sp,
            color: isFavorite ? errorColor : Colors.black,
          ),
        ),
      ),
    );
  }

  IconData getIcon() {
    if (isFavorite) {
      return Iconsax.heart5;
    } else {
      return Iconsax.heart;
    }
  }

  bool get isFavorite {
    return response.bookmarked;
  }
}
