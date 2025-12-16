import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/doctors/presentation/view/all_doctors_screen.dart';

class ClinicTile extends StatelessWidget {
  final int centerID;
  final String clinicName;
  final int clinicID;

  const ClinicTile({
    super.key,
    required this.centerID,
    required this.clinicName,
    required this.clinicID,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.medical_services, color: Colors.teal),
        title: Text(
          clinicName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.pushNamed(
            context,
            AllDoctorsScreen.routeName,
            arguments: {'centerID': centerID, 'specialtyID': clinicID},
          );
        },
      ),
    );
  }
}
