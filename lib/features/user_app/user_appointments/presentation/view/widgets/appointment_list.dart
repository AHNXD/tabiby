import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_localizations.dart';
import '../../../../../../core/widgets/no_data.dart';
import '../../../data/models/appointments_model.dart';
import 'appointment_item.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  final String status;
  const AppointmentList({
    super.key,
    required this.appointments,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return NoDataWidget(
        title: "no_data_title".tr(context),
        subtitle: "no_data_subtitle".tr(context),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appt = appointments[index];
        return AppointmentItem(appointment: appt, status: status);
      },
    );
  }
}
