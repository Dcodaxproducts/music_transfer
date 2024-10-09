import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/colors.dart';

class ModelsView extends StatefulWidget {
  const ModelsView({super.key});

  @override
  State<ModelsView> createState() => _ModelsViewState();
}

class _ModelsViewState extends State<ModelsView> {
  final List<AIModelCard> models = [
    const AIModelCard(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Imagine',
      description: 'High quality images within 3 seconds',
      statusLabel: 'HOT',
      isPremium: true,
    ),
    const AIModelCard(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Tattoo',
      description: 'Colored and BW Tattoo Art',
      statusLabel: 'HOT',
      isPremium: false,
    ),
    const AIModelCard(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Product',
      description: 'Professional product design illustrations',
      statusLabel: 'HOT',
      isPremium: false,
    ),
    const AIModelCard(
      imageUrl: 'https://via.placeholder.com/150',
      title: 'Logo',
      description: 'Stunning, efficient logo creation',
      statusLabel: 'HOT',
      isPremium: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 8.sp),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.sp,
        crossAxisSpacing: 16.sp,
        childAspectRatio: 0.8,
      ),
      itemCount: models.length,
      itemBuilder: (context, index) {
        return models[index];
      },
    );
  }
}

class AIModelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String statusLabel;
  final bool isPremium;

  const AIModelCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.statusLabel,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPremium ? primaryColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.sp),
                    ),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (isPremium)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Iconsax.crown,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.sp),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
