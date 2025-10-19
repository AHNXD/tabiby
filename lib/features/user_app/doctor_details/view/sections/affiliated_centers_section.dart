import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../widgets/center_card.dart';

class AffiliatedCentersSection extends StatelessWidget {
  final List<Map<String, dynamic>> centers;

  const AffiliatedCentersSection({super.key, required this.centers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'affiliated_centers'.tr(context),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ...centers.map(
          (center) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CenterCard(
              centerName: center['centerName'],
              price: center['price'],
              availableDays: List<String>.from(center['availableDays']),
            ),
          ),
        ),
      ],
    );
  }
}
