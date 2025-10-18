import 'package:flutter/material.dart';

class ClinicTile extends StatelessWidget {
  final String clinicName;
  final String specialty;

  const ClinicTile({super.key, required this.clinicName, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.medical_services, color: Colors.teal),
        title: Text(clinicName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Specialty: $specialty', style: TextStyle(color: Colors.grey[700])),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}
