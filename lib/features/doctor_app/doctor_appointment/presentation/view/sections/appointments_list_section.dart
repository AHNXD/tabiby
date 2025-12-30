import 'package:flutter/material.dart';
import '../../../data/models/doctor_appointments_model.dart';
import '../widgets/appointment_card.dart';
import 'empty_state_section.dart';

class AppointmentsListSection extends StatelessWidget {
  final List<DoctorAppointmentData> appointments;
  final Future<void> Function() onRefresh;
  const AppointmentsListSection({
    super.key,
    required this.appointments,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) return const EmptyStateSection();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: appointments.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, index) => AppointmentCard(
          appointment: appointments[index],
          onRefresh: onRefresh,
        ),
      ),
    );
  }
}
