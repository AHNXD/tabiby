import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../doctor_appointment/data/models/doctor_appointments_model.dart';
import 'sections/bottom_buttons_section.dart';
import 'sections/patient_info_section.dart';
import 'sections/scheduled_time_section.dart';
import 'widgets/appointment_details_header.dart';
import 'widgets/end_appointment_dialog.dart';

class AppointmentDetailsDoctor extends StatelessWidget {
  static const String routeName = "/doctor_appointment_details";
  final DoctorAppointmentData appointment;
  const AppointmentDetailsDoctor({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppbar(title: "appointment_details".tr(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppointmentDetailsHeader(
                appointment: appointment,
                primaryColor: AppColors.primaryColors,
              ),
              const SizedBox(height: 24),
              const PatientInfoSection(),
              const SizedBox(height: 40),

              ScheduledTimeSection(appointment: appointment),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomButtonsSection(
        onCancel: () => Navigator.of(context).pop(),
        onEndAppointment: () => _showEndAppointmentDialog(context),
      ),
    );
  }

  void _showEndAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) =>
          EndAppointmentDialog(primaryColor: AppColors.primaryColors),
    );
  }
}
