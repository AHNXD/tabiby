import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class DoctorHeader extends StatelessWidget {
  final String name;
  final String specialty;
  final String experience;
  final String imageUrl;

  const DoctorHeader({
    super.key,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 45, backgroundImage: AssetImage(imageUrl)),
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
