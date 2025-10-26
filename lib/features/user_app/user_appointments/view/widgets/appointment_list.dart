import 'package:flutter/material.dart';
import 'appointment_item.dart';

class AppointmentList extends StatelessWidget {
  final List<Map<String, String>> appointments;

  const AppointmentList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appt = appointments[index];
        return AppointmentItem(
          day: appt['day']!,
          month: appt['month']!,
          doctorName: appt['doctorName']!,
          specialty: appt['specialty']!,
          time: appt['time']!,
          rating: appt['rating']!,
          avatarUrl: appt['avatarUrl']!,
          doctorNotes: appt['doctorNotes'],
          prescription: appt['prescription'],
        );
      },
    );
  }
}
