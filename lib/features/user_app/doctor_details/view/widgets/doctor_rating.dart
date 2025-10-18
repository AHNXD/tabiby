import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';

class DoctorRating extends StatelessWidget {
  final String rating;

  const DoctorRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 22),
        const SizedBox(width: 4),
        Text(
          rating,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '(234 Reviews)',
          style: TextStyle(fontSize: 15, color: AppColors.lightTextColor),
        ),
      ],
    );
  }
}
