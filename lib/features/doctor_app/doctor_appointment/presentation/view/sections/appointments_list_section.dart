import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../../../data/models/doctor_appointments_model.dart'; 
import 'appointment_section.dart';
import 'empty_state_section.dart';

class AppointmentsListSection extends StatelessWidget {
  final List<DoctorAppointmentData> appointments; 

  const AppointmentsListSection({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {

    final groupedAppointments = groupBy(
      appointments,
      (DoctorAppointmentData appointment) => appointment.patientName ?? ' ', 
    );

    if (groupedAppointments.isEmpty) return const EmptyStateSection();

    return Column(
      children: groupedAppointments.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: AppointmentSection(
            centerName: entry.key,
            appointments: entry.value,
          ),
        );
      }).toList(),
    );
  }
}