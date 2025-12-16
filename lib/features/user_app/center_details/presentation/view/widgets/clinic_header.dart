import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../../../../core/widgets/custom_image_widget.dart';

class ClinicHeader extends StatelessWidget {
  final String name;
  final String address;
  final String? imageUrl;

  const ClinicHeader({
    super.key,
    required this.name,
    required this.address,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CustomImageWidget(
            imageUrl: imageUrl,
            placeholderAsset: "assets/images/center.webp",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }
}
