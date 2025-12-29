import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../view_model/end_appointment_cubit/end_appointment_cubit.dart';

class EndAppointmentDialog extends StatefulWidget {
  final Color primaryColor;
  final int appointmentId;

  const EndAppointmentDialog({super.key, required this.primaryColor, required this.appointmentId});

  @override
  State<EndAppointmentDialog> createState() => _EndAppointmentDialogState();
}

class _EndAppointmentDialogState extends State<EndAppointmentDialog> {
  final TextEditingController notesController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();
  final List<Map<String, String>> prescriptions = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'complete_appointment'.tr(context),
        style: TextStyle(color: widget.primaryColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'notes'.tr(context),
              style: TextStyle(
                color: widget.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'hint_add_clinical_notes'.tr(context),
                filled: true,
                fillColor: widget.primaryColor.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'prescription'.tr(context),
              style: TextStyle(
                color: widget.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
                controller: prescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Add the medication, dose, and duration'.tr(context),
                  filled: true,
                  fillColor: widget.primaryColor.withValues(alpha: 0.1),
                ),
              ),

          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'cancel'.tr(context),
            style: TextStyle(color: widget.primaryColor),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
          child: Text('submit'.tr(context)),
         onPressed: () {
        context.read<EndAppointmentCubit>().endAppointment(
        widget.appointmentId,
        notesController.text,
        prescriptionController.text,
      );

  Navigator.of(context).pop();
},
        ),
      ],
    );
  }
@override
void dispose() {
  notesController.dispose();
  prescriptionController.dispose();
  super.dispose();
}

}
