import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../core/utils/assets_data.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage(AssetsData.defaultProfileImage),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mr . Esam Derawan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.bodyTextColor,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '2008 / 21 / 5',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryBodyTextColor,
              ),
            ),

            const SizedBox(height: 4),
            Text(
              '1 ${"appointment".tr(context)}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryBodyTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
