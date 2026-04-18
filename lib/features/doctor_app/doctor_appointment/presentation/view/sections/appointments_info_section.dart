import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
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
      '${"you_have".tr(context)} $appointmentCount ${"appointments_for".tr(context)} "${selectedDate.tr(context)}".',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.grey600Color,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
