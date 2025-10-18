import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../widgets/appointment_details_card.dart';

class PatientInfoSection extends StatelessWidget {
  const PatientInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Patient Information",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primaryColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const AppointmentDetailsCard(),
      ],
    );
  }
}
