import 'package:flutter/material.dart';

class AppointmentsInfoSection extends StatelessWidget {
  final int appointmentCount;
  final String selectedDate;

  const AppointmentsInfoSection({
    super.key,
    required this.appointmentCount,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'You have $appointmentCount appointments for "$selectedDate".',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal,
          ),
    );
  }
}
