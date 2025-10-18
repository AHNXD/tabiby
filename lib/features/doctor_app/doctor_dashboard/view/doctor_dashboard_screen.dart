import 'package:flutter/material.dart';
import 'sections/appointments_info_section.dart';
import 'sections/appointments_list_section.dart';
import 'sections/dashboard_scaffold_section.dart';
import 'sections/filters_section.dart';
import 'widgets/dashboard_controller.dart';
import 'widgets/data.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends State<DoctorDashboardScreen> {
  String _selectedDateFilter = 'Today';
  String _selectedCenterFilter = 'All';
  List<Map<String, dynamic>> _filteredAppointments = [];
  final _controller = DashboardController();

  @override
  void initState() {
    super.initState();
    _updateAppointments();
  }

  void _updateAppointments() {
    setState(() {
      _filteredAppointments = _controller.filterAppointments(
        allAppointments: allAppointments,
        selectedDateFilter: _selectedDateFilter,
        selectedCenterFilter: _selectedCenterFilter,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          const SizedBox(height: 16),
          AppointmentsInfoSection(
            appointmentCount: _filteredAppointments.length,
            selectedDate: _selectedDateFilter,
          ),
          const SizedBox(height: 24),
          FiltersSection(
            selectedDate: _selectedDateFilter,
            selectedCenter: _selectedCenterFilter,
            onDateChanged: (value) {
              if (value != null) {
                setState(() => _selectedDateFilter = value);
                _updateAppointments();
              }
            },
            onCenterChanged: (value) {
              if (value != null) {
                setState(() => _selectedCenterFilter = value);
                _updateAppointments();
              }
            },
          ),
          const SizedBox(height: 32),
          AppointmentsListSection(appointments: _filteredAppointments),
        ],
      ),
    );
  }
}
