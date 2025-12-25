import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../../doctor_appointment/data/models/doctor_appointments_model.dart';

class ScheduledTimeSection extends StatelessWidget {
  final DoctorAppointmentData appointment;
  const ScheduledTimeSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${"scheduled_for".tr(context)} ${appointment.date}, "
        "${appointment.date}/${appointment.date}/${appointment.date}",
        style: TextStyle(color: AppColors.primaryColors),
      ),
    );
  }
}
