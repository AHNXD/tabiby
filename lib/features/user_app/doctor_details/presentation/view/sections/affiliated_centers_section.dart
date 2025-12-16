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
        Text(
          'affiliated_centers'.tr(context),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(shrinkWrap: true,itemCount: centers.length ,itemBuilder: (context, index) {
          final center = centers[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: CenterCard(
              center: center
            ),
          );
        },
    )],
    );
  }
}
