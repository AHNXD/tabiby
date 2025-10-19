import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../core/widgets/secondry_button.dart';
import '../../../../user_appointments/view/appointment_screen.dart';

class AppointmentsSection extends StatelessWidget {
  const AppointmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondryButton(
            text: 'my_appointments'.tr(context),
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
