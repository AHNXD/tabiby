import 'package:flutter/material.dart';
import '../../../data/models/appointments_model.dart';
import 'appointment_item.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appt = appointments[index];
        return AppointmentItem(appointment: appt);
      },
    );
  }
}
