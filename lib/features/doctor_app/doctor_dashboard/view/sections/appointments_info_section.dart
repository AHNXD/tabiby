import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

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
      '${"you_have".tr(context)} $appointmentCount ${"appointments_for".tr(context)} "$selectedDate".',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal,
          ),
    );
  }
}
