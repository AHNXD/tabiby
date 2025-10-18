import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import '../widgets/clinic_tile.dart';

class ClinicsSection extends StatelessWidget {
  const ClinicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 30),
        Text(
          'Clinics & Departments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColors,
          ),
        ),
        Divider(height: 10, thickness: 1),
        SizedBox(height: 20),
        ClinicTile(
          clinicName: 'Cardiology Unit',
          specialty: 'Heart & Vascular',
        ),
        ClinicTile(
          clinicName: 'Orthopedics Clinic',
          specialty: 'Bone & Joint',
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
