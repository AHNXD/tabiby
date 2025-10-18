import 'package:flutter/material.dart';

class PatientInfoCard extends StatelessWidget {
  const PatientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/images/doctor1.jpg'),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mr . Esam Derawan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '2008 / 21 / 5',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),

            
            const SizedBox(height: 4),
            const Text(
              '1 Appointment',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
