import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

class EndAppointmentDialog extends StatefulWidget {
  final Color primaryColor;

  const EndAppointmentDialog({super.key, required this.primaryColor});

  @override
  State<EndAppointmentDialog> createState() => _EndAppointmentDialogState();
}

class _EndAppointmentDialogState extends State<EndAppointmentDialog> {
  final TextEditingController notesController = TextEditingController();
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
            _buildPrescriptionForm(),
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
            if (kDebugMode) {
              print('Notes: ${notesController.text}');
              print('Prescriptions: $prescriptions');
            }

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildPrescriptionForm() {
    return Column(
      children: [
        const SizedBox(height: 4),
        _buildMedicationRow(),
        const SizedBox(height: 8),
        TextButton.icon(
          icon: Icon(Icons.add_circle_outline, color: widget.primaryColor),
          label: Text(
            'add_medication'.tr(context),
            style: TextStyle(color: widget.primaryColor),
          ),
          onPressed: () {
            setState(() {
              prescriptions.add({'medication': '', 'dose': '', 'duration': ''});
            });
          },
        ),
      ],
    );
  }

  Widget _buildMedicationRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'medication'.tr(context),
              hintStyle: TextStyle(color: widget.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'dose'.tr(context),
              hintStyle: TextStyle(color: widget.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'duration'.tr(context),
              hintStyle: TextStyle(color: widget.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
