import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class ScheduledTimeSection extends StatelessWidget {
  final Map<String, dynamic> appointment;
  const ScheduledTimeSection({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Scheduled for ${appointment['time']}, "
        "${appointment['date'].day}/${appointment['date'].month}/${appointment['date'].year}",
        style: TextStyle(color: AppColors.primaryColors),
      ),
    );
  }
}
