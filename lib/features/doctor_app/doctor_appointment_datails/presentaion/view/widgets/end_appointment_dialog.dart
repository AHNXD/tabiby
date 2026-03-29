import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/models/prescription_item.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';

import '../../view_model/end_appointment_cubit/end_appointment_cubit.dart';
import '../../view_model/end_appointment_cubit/end_appointment_state.dart';

class EndAppointmentDialog extends StatefulWidget {
  final Color primaryColor;
  final int appointmentId;

  const EndAppointmentDialog({
    super.key,
    required this.primaryColor,
    required this.appointmentId,
  });

  @override
  State<EndAppointmentDialog> createState() => _EndAppointmentDialogState();
}

class _EndAppointmentDialogState extends State<EndAppointmentDialog> {
  final TextEditingController notesController = TextEditingController();
  final List<_MedicationFormEntry> medicationEntries = <_MedicationFormEntry>[
    _MedicationFormEntry(),
  ];

  @override
  void dispose() {
    notesController.dispose();
    for (final _MedicationFormEntry entry in medicationEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _addMedicationEntry() {
    setState(() {
      medicationEntries.add(_MedicationFormEntry());
    });
  }

  void _removeMedicationEntry(int index) {
    if (medicationEntries.length == 1) {
      medicationEntries.first.clear();
      setState(() {});
      return;
    }

    final _MedicationFormEntry entry = medicationEntries.removeAt(index);
    entry.dispose();
    setState(() {});
  }

  List<PrescriptionItem>? _buildPrescriptionList() {
    final List<PrescriptionItem> items = <PrescriptionItem>[];

    for (final _MedicationFormEntry entry in medicationEntries) {
      if (entry.isCompletelyEmpty) {
        continue;
      }

      if (!entry.isValid) {
        return null;
      }

      items.add(entry.toPrescriptionItem());
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: BlocListener<EndAppointmentCubit, EndAppointmentState>(
        listener: (context, state) {
          if (state is EndAppointmentSuccess) {
            messages(context, state.message, Colors.green);
            Navigator.of(context).pop(true);
          } else if (state is EndAppointmentFailure) {
            messages(context, state.error, Colors.red);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'complete_appointment'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: widget.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader(
                  context,
                  icon: Icons.note_alt_rounded,
                  title: 'general_notes'.tr(context),
                ),
                const SizedBox(height: 12),
                _buildStyledTextField(
                  context,
                  controller: notesController,
                  hint: 'hint_add_clinical_notes'.tr(context),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildSectionHeader(
                  context,
                  icon: Icons.medication_rounded,
                  title: 'prescription_list'.tr(context),
                ),
                const SizedBox(height: 12),
                ...List<Widget>.generate(
                  medicationEntries.length,
                  (int index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _MedicationEntryCard(
                      entry: medicationEntries[index],
                      index: index,
                      primaryColor: widget.primaryColor,
                      onRemove: () => _removeMedicationEntry(index),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addMedicationEntry,
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: widget.primaryColor,
                    ),
                    label: Text(
                      'add_medication'.tr(context),
                      style: TextStyle(
                        color: widget.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<EndAppointmentCubit, EndAppointmentState>(
                  builder: (context, state) {
                    if (state is EndAppointmentLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: widget.primaryColor,
                        ),
                      );
                    }

                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final List<PrescriptionItem>? prescriptionList =
                                  _buildPrescriptionList();

                              if (prescriptionList == null) {
                                messages(
                                  context,
                                  'complete_medication_fields'.tr(context),
                                  Colors.orange,
                                );
                                return;
                              }

                              context
                                  .read<EndAppointmentCubit>()
                                  .endAppointment(
                                    widget.appointmentId,
                                    notesController.text,
                                    prescriptionList,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              elevation: 4,
                              shadowColor: widget.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'submit'.tr(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            'cancel'.tr(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: widget.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStyledTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    VoidCallback? onTap,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: widget.primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _MedicationEntryCard extends StatefulWidget {
  const _MedicationEntryCard({
    required this.entry,
    required this.index,
    required this.primaryColor,
    required this.onRemove,
  });

  final _MedicationFormEntry entry;
  final int index;
  final Color primaryColor;
  final VoidCallback onRemove;

  @override
  State<_MedicationEntryCard> createState() => _MedicationEntryCardState();
}

class _MedicationEntryCardState extends State<_MedicationEntryCard> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${"medication".tr(context)} ${widget.index + 1}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onRemove,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildField(
            context,
            controller: widget.entry.drugNameController,
            hint: 'drug_name'.tr(context),
          ),
          const SizedBox(height: 10),
          _buildField(
            context,
            controller: widget.entry.dosageController,
            hint: 'dosage'.tr(context),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  context,
                  controller: widget.entry.startDateController,
                  hint: 'start_date'.tr(context),
                  readOnly: true,
                  onTap: () => _pickDate(widget.entry.startDateController),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildField(
                  context,
                  controller: widget.entry.endDateController,
                  hint: 'end_date'.tr(context),
                  readOnly: true,
                  onTap: () => _pickDate(widget.entry.endDateController),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildField(
            context,
            controller: widget.entry.frequencyController,
            hint: 'frequency_per_day'.tr(context),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          _buildField(
            context,
            controller: widget.entry.specialNotesController,
            hint: 'special_notes'.tr(context),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: widget.primaryColor, width: 1.5),
        ),
      ),
    );
  }
}

class _MedicationFormEntry {
  final TextEditingController drugNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController specialNotesController = TextEditingController();

  bool get isCompletelyEmpty =>
      drugNameController.text.trim().isEmpty &&
      dosageController.text.trim().isEmpty &&
      startDateController.text.trim().isEmpty &&
      endDateController.text.trim().isEmpty &&
      frequencyController.text.trim().isEmpty &&
      specialNotesController.text.trim().isEmpty;

  bool get isValid =>
      drugNameController.text.trim().isNotEmpty &&
      dosageController.text.trim().isNotEmpty &&
      startDateController.text.trim().isNotEmpty &&
      endDateController.text.trim().isNotEmpty &&
      frequencyController.text.trim().isNotEmpty;

  PrescriptionItem toPrescriptionItem() {
    return PrescriptionItem(
      drugName: drugNameController.text.trim(),
      dosage: dosageController.text.trim(),
      startDate: startDateController.text.trim(),
      endDate: endDateController.text.trim(),
      frequencyPerDay: frequencyController.text.trim(),
      specialNotes: specialNotesController.text.trim(),
    );
  }

  void clear() {
    drugNameController.clear();
    dosageController.clear();
    startDateController.clear();
    endDateController.clear();
    frequencyController.clear();
    specialNotesController.clear();
  }

  void dispose() {
    drugNameController.dispose();
    dosageController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    frequencyController.dispose();
    specialNotesController.dispose();
  }
}
