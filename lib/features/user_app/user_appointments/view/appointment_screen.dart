import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../add_appointment/view/booking_screen.dart';
import 'widgets/colored_text_bar.dart';
import 'widgets/patient_info_card.dart';

import 'widgets/appointment_list.dart';
import 'widgets/data.dart';

class UserAppointmentScreen extends StatelessWidget {
  static const String routeName = "/user_appointments";
  const UserAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const PatientInfoCard(),
                const SizedBox(height: 16),
                const ColoredTextTabBar(),
                const SizedBox(height: 16),

                Expanded(
                  child: TabBarView(
                    children: [
                      AppointmentList(appointments: finishedAppointments),
                      AppointmentList(appointments: pendingAppointments),
                      AppointmentList(appointments: canceledAppointments),
                    ],
                  ),
                ),

                PrimaryButton(
                  text: 'add_appointment'.tr(context),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
