import 'package:flutter/material.dart';
import 'appointment_detail_row.dart';

class AppointmentDetailsCard extends StatelessWidget {


  const AppointmentDetailsCard({super.key,});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: const [
            
            AppointmentDetailRow(icon: Icons.person_outline, label: 'Gender', value: 'Female'),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(icon: Icons.cake_outlined, label: 'Age', value: '34 years'),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(icon: Icons.height, label: 'Height', value: '168 cm'),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(icon: Icons.monitor_weight_outlined, label: 'Weight', value: '65 kg'),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(icon: Icons.smoking_rooms, label: 'Smoker', value: 'No'),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(icon: Icons.favorite_border, label: 'Marital Status', value: 'Married'),
          ],
        ),
      ),
    );
  }
}
