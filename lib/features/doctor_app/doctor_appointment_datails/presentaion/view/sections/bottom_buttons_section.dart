import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(bottom: 28),
      child: Row(
        children: [
          Expanded(
            child: SecondryButton(
              text: 'cancel'.tr(context),
              onPressed: onCancel,
            ),
          ),

          const SizedBox(width: 8),

          // End Appointment Button
          Expanded(
            child: PrimaryButton(
              text: 'end_appointment'.tr(context),
              onPressed: onEndAppointment,
            ),
          ),
        ],
      ),
    );
  }
}
