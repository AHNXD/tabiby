import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../data/models/doctor_model.dart';
import '../widgets/center_card.dart';

class AffiliatedCentersSection extends StatelessWidget {
  final List<DoctorCenters> centers;

  const AffiliatedCentersSection({super.key, required this.centers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'affiliated_centers'.tr(context),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2C28),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'doctor_details'.tr(context),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${centers.length}',
                style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: centers.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final center = centers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: CenterCard(center: center),
            );
          },
        ),
      ],
    );
  }
}
