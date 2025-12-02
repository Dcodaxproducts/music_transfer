import 'package:pixart_app/features/subscription/data/model/subscription_item.dart';
import 'package:pixart_app/features/language/presentation/view/language.dart';
import '../../../../../imports.dart';

class SubscriptionPackageWidget extends StatelessWidget {
  final SubscriptionItem item;
  final bool selected;
  final Function() onTap;
  const SubscriptionPackageWidget({
    required this.item,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.sp),
          child: TextButton(
            onPressed: onTap,
            child: Container(
              padding: AppPadding.padding12,
              decoration: BoxDecoration(
                borderRadius: AppRadius.circular16,
                color: cardColorDark.withOpacity(0.7),
                border: Border.all(color: selected ? primaryColor : dividerColorDark),
              ),
              child: Row(
                children: [
                  LanguageRadioButton(selected: selected),
                  SizedBox(width: 8.sp),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title.tr, style: context.font14.copyWith(color: Colors.white)),
                        SizedBox(height: 4.sp),
                        Text(item.subtitle.tr, style: context.font12.copyWith(color: Colors.grey[400])),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.sp),
                  Text(item.price, style: context.font14.copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
        if (item.promotionText.isNotEmpty)
          Positioned(
            top: 0.sp,
            right: 32.sp,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.sp),
                color: selected ? primaryColor : dividerColorDark,
              ),
              child: Text(
                item.promotionText.toUpperCase(),
                style: context.font10.copyWith(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
