import 'package:flutter/material.dart';


class DashboardController {
  List<Map<String, dynamic>> filterAppointments({
    required List<Map<String, dynamic>> allAppointments,
    required String selectedDateFilter,
    required String selectedCenterFilter,
  }) {
    List<Map<String, dynamic>> appointments = List.from(allAppointments);
    final now = DateTime.now();

    // Date Filter
    if (selectedDateFilter == 'Today') {
      appointments = appointments
          .where((a) => DateUtils.isSameDay(a['date'], now))
          .toList();
    } else if (selectedDateFilter == 'Tomorrow') {
      appointments = appointments
          .where((a) => DateUtils.isSameDay(a['date'], now.add(const Duration(days: 1))))
          .toList();
    } else if (selectedDateFilter == 'This Week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      appointments = appointments.where((a) {
        final date = a['date'] as DateTime;
        return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            date.isBefore(endOfWeek.add(const Duration(days: 1)));
      }).toList();
    }

    // Center Filter
    if (selectedCenterFilter != 'All') {
      appointments =
          appointments.where((a) => a['centerName'] == selectedCenterFilter).toList();
    }

    return appointments;
  }
}
