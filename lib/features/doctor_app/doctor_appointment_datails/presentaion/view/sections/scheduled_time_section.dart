import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/doctor_app/doctor_appointment_datails/data/models/doctor_appointment_details_model.dart';

class ScheduledTimeSection extends StatelessWidget {
  final DoctorAppointmentDetailsModel appointment;
  const ScheduledTimeSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${"scheduled_for".tr(context)} ${appointment.date}",
        style: TextStyle(color: AppColors.primaryColors),
      ),
    );
  }
}
