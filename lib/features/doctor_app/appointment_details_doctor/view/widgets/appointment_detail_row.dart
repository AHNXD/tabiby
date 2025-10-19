import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class AppointmentDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AppointmentDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {


    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColors),
      title: Text(label, style: TextStyle(color: AppColors.primaryColors)),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
