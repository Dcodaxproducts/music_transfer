import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/colors.dart';

class SubscriptionPackageWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final Function() onTap;
  final String price;
  const SubscriptionPackageWidget(
      {required this.selected,
      required this.title,
      required this.onTap,
      required this.price,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: selected ? primaryColor : Colors.grey[800]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selected ? Colors.white : null,
                border: selected
                    ? null
                    : Border.all(width: 1.5, color: Colors.white),
              ),
              child: selected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.black,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Auto-renewable',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 30,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SubscriptionPackageWidget extends StatelessWidget {
//   final String title;
//   final bool selected;
//   final Function() onTap;
//   const SubscriptionPackageWidget(
//       {required this.selected,
//       required this.title,
//       required this.onTap,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: selected
//               ? Theme.of(context).primaryColor
//               : const Color(0xFF242424),
//           border: Border.all(
//             width: 1,
//             color: selected ? primaryColor : Colors.grey[800]!,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: selected ? const Color(0xFF242424) : null,
//                 border: selected
//                     ? null
//                     : Border.all(width: 1.5, color: Colors.white),
//               ),
//               child: selected
//                   ? const Icon(
//                       Icons.check,
//                       size: 16,
//                       color: Colors.white,
//                     )
//                   : null,
//             ),
//             const SizedBox(height: 28),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: selected
//                     ? Theme.of(context).scaffoldBackgroundColor
//                     : Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
