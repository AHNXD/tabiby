import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class BiographySection extends StatelessWidget {
  final String biography;

  const BiographySection({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Biography',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          biography,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.lightTextColor,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
