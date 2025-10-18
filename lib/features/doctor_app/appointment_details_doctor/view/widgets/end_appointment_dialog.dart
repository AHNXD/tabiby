import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
        'Complete Appointment',
        style: TextStyle(color: widget.primaryColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
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
                hintText: 'Add clinical notes here...',
                filled: true,
                fillColor: widget.primaryColor.withValues(alpha: 0.1),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prescription',
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
          child: Text('Cancel', style: TextStyle(color: widget.primaryColor)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
          child: const Text('Submit'),
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
            'Add Medication',
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
              hintText: 'Medication',
              hintStyle: TextStyle(color: widget.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Dose',
              hintStyle: TextStyle(color: widget.primaryColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Duration',
              hintStyle: TextStyle(color: widget.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
