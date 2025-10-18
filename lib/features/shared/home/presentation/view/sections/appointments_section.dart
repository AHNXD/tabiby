import 'package:flutter/material.dart';

import '../../../../../../core/widgets/secondry_button.dart';
import '../../../../../user_app/user_appointments/view/appointment_screen.dart';



class AppointmentsSection extends StatelessWidget {
  const AppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondryButton(
            text: 'My Appointments',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserAppointmentScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
