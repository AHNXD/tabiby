import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';

import '../../data/models/end_appointment_request.dart';

class EndAppointmentMedicationFormScreen extends StatefulWidget {
  final EndAppointmentPrescriptionItem? initialItem;

  const EndAppointmentMedicationFormScreen({super.key, this.initialItem});

  @override
  State<EndAppointmentMedicationFormScreen> createState() =>
      _EndAppointmentMedicationFormScreenState();
}

class _EndAppointmentMedicationFormScreenState
    extends State<EndAppointmentMedicationFormScreen> {
  late final TextEditingController _medicineNameController;
  late final TextEditingController _doseController;
  late final TextEditingController _frequencyController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _instructionsController;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController(
      text: widget.initialItem?.medicineName ?? '',
    );
    _doseController = TextEditingController(
      text: widget.initialItem?.dose ?? '',
    );
    _frequencyController = TextEditingController(
      text: widget.initialItem?.frequency ?? '',
    );
    _startDateController = TextEditingController(
      text: widget.initialItem?.startDate ?? '',
    );
    _endDateController = TextEditingController(
      text: widget.initialItem?.endDate ?? '',
    );
    _instructionsController = TextEditingController(
      text: widget.initialItem?.instructions ?? '',
    );
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _doseController.dispose();
    _frequencyController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime.tryParse(controller.text) ?? now;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) {
      return;
    }

    controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    setState(() {});
  }

  void _saveMedication() {
    if (_medicineNameController.text.trim().isEmpty ||
        _doseController.text.trim().isEmpty ||
        _frequencyController.text.trim().isEmpty ||
        _startDateController.text.trim().isEmpty ||
        _endDateController.text.trim().isEmpty) {
      messages(
        context,
        'complete_medication_fields'.tr(context),
        AppColors.orangeColor,
      );
      return;
    }

    Navigator.of(context).pop(
      EndAppointmentPrescriptionItem(
        medicineName: _medicineNameController.text.trim(),
        dose: _doseController.text.trim(),
        frequency: _frequencyController.text.trim(),
        startDate: _startDateController.text.trim(),
        endDate: _endDateController.text.trim(),
        instructions: _instructionsController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softSurfaceMutedColor,
      appBar: CustomAppbar(
        title:
            (_isEditing
                    ? 'edit_prescription_medication'
                    : 'add_prescription_medication')
                .tr(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              _MedicationFieldCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _MedicationTextField(
                      controller: _medicineNameController,
                      hint: 'drug_name'.tr(context),
                    ),
                    const SizedBox(height: 12),
                    _MedicationTextField(
                      controller: _doseController,
                      hint: 'dose'.tr(context),
                    ),
                    const SizedBox(height: 12),
                    _MedicationTextField(
                      controller: _frequencyController,
                      hint: 'frequency_per_day'.tr(context),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _MedicationTextField(
                            controller: _startDateController,
                            hint: 'start_date'.tr(context),
                            readOnly: true,
                            onTap: () => _pickDate(_startDateController),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MedicationTextField(
                            controller: _endDateController,
                            hint: 'end_date'.tr(context),
                            readOnly: true,
                            onTap: () => _pickDate(_endDateController),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _MedicationTextField(
                      controller: _instructionsController,
                      hint: 'special_notes'.tr(context),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: _saveMedication,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'save_changes'.tr(context),
              style: const TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicationFieldCard extends StatelessWidget {
  final Widget child;

  const _MedicationFieldCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MedicationTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool readOnly;
  final int maxLines;
  final VoidCallback? onTap;

  const _MedicationTextField({
    required this.controller,
    required this.hint,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.lightSurfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey300Color),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.grey300Color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryColors),
        ),
      ),
    );
  }
}
