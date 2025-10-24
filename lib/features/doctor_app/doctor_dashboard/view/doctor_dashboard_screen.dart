import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'sections/appointments_info_section.dart';
import 'sections/appointments_list_section.dart';
import 'sections/dashboard_scaffold_section.dart';
import 'sections/filters_section.dart';
import 'widgets/dashboard_controller.dart';
import 'widgets/data.dart';

class DoctorDashboardScreen extends StatefulWidget {
  static const String routeName = "/doctor_dashboard";

  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardViewState();
}

class _DoctorDashboardViewState extends State<DoctorDashboardScreen> {
  late String _selectedDateFilter;
  late String _selectedCenterFilter;
  List<Map<String, dynamic>> _filteredAppointments = [];
  final _controller = DashboardController();

  bool _isInitialSetup = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialSetup) {
      _selectedDateFilter = 'today'.tr(context);
      _selectedCenterFilter = 'all'.tr(context);

      _filteredAppointments = _controller.filterAppointments(
        allAppointments: allAppointments,
        selectedDateFilter: _selectedDateFilter,
        selectedCenterFilter: _selectedCenterFilter,
        context: context,
      );

      _isInitialSetup = false;
    }
  }

  void _updateAppointments() {
    setState(() {
      _filteredAppointments = _controller.filterAppointments(
        allAppointments: allAppointments,
        selectedDateFilter: _selectedDateFilter,
        selectedCenterFilter: _selectedCenterFilter,
        context: context,
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
                _updateAppointments(); // Recalculate based on new filter
              }
            },
            onCenterChanged: (value) {
              if (value != null) {
                setState(() => _selectedCenterFilter = value);
                _updateAppointments(); // Recalculate based on new filter
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
