import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class BottomButtonsSection extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onEndAppointment;

  const BottomButtonsSection({
    super.key,
    required this.onCancel,
    required this.onEndAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0).copyWith(bottom: 28),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColors,
                side: BorderSide(color: AppColors.primaryColors),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onCancel,
            ),
          ),
          const SizedBox(width: 16),

          // End Appointment Button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('End Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColors,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onEndAppointment,
            ),
          ),
        ],
      ),
    );
  }
}
