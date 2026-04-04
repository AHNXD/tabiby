import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointments_model.dart';

import 'appointment_item.dart';

class AppointmentList extends StatelessWidget {
  const AppointmentList({
    super.key,
    required this.appointments,
    required this.status,
  });

  final List<Appointment> appointments;
  final String status;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(top: 24, bottom: 24),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: NoDataWidget(
              icon: _iconForStatus(),
              title: "no_data_title".tr(context),
              subtitle: "no_data_subtitle".tr(context),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 4),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final Appointment appointment = appointments[index];
        return AppointmentItem(appointment: appointment, status: status);
      },
    );
  }

  IconData _iconForStatus() {
    switch (status) {
      case 'completed':
        return Icons.assignment_turned_in_outlined;
      case 'canceled':
        return Icons.event_busy_outlined;
      default:
        return Icons.schedule_outlined;
    }
  }
}
