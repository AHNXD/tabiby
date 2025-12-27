import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';


import '../../../data/models/doctor_appointment_details_model.dart';
import '../widgets/appointment_details_card.dart';

class PatientInfoSection extends StatelessWidget {
  const PatientInfoSection({super.key, required this.appointmentDetails});

  final DoctorAppointmentDetailsModel appointmentDetails;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "patient_information".tr(context),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primaryColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
         AppointmentDetailsCard(appointmentDetails: appointmentDetails ),
      ],
    );
  }
}
