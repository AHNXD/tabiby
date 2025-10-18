import 'package:flutter/material.dart';

import 'appointment_card.dart';

class Appointment extends StatelessWidget {
  final String centerName;
  final List<Map<String, dynamic>> appointments;

  const Appointment({
    super.key,
    required this.centerName,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(centerName, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, index) =>
              AppointmentCard(appointment: appointments[index]),
        ),
      ],
    );
  }
}
