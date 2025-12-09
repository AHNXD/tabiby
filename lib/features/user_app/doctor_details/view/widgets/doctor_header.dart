import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../../../core/widgets/custom_image_widget.dart';

class DoctorHeader extends StatelessWidget {
  final String name;
  final String specialty;
  final String experience;
  final String? imageUrl;
  final int rate;

  const DoctorHeader({
    super.key,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.imageUrl,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: CustomImageWidget(
            imageUrl: imageUrl,
            placeholderAsset: "assets/images/doctor.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              specialty,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryColors,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              experience,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.lightTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
