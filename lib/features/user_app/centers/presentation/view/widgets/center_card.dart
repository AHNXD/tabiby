import 'package:flutter/material.dart';
import 'package:tabiby/core/widgets/responsive_text.dart';
import 'package:tabiby/features/user_app/center_details/data/models/centers_model.dart';

import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';

class CenterCard extends StatelessWidget {
  final Centers center;
  const CenterCard({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: CustomImageWidget(
              imageUrl: center.img,
              placeholderAsset: AssetsData.defaultCenter,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),
          ResponsiveText(
            center.name ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          ResponsiveText(
            center.address ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
