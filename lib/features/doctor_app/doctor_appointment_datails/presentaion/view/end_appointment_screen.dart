import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';

import '../../data/models/appointment_request_option.dart';
import '../../data/models/doctor_appointment_details_model.dart';
import '../../data/models/end_appointment_request.dart';
import '../view_model/end_appointment_cubit/end_appointment_cubit.dart';
import '../view_model/end_appointment_cubit/end_appointment_state.dart';
import 'end_appointment_medication_form_screen.dart';

class EndAppointmentScreen extends StatefulWidget {
  final DoctorAppointmentDetailsModel appointment;

  const EndAppointmentScreen({super.key, required this.appointment});

  @override
  State<EndAppointmentScreen> createState() => _EndAppointmentScreenState();
}

class _EndAppointmentScreenState extends State<EndAppointmentScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _prescriptionNoteController =
      TextEditingController();
  final TextEditingController _labRequestNoteController =
      TextEditingController();
  final List<EndAppointmentPrescriptionItem> _medications =
      <EndAppointmentPrescriptionItem>[];
  final List<_RadiologyRequestDraft> _radiologyEntries =
      <_RadiologyRequestDraft>[];
  final Set<int> _selectedLabTestIds = <int>{};

  bool _sendToPharmacy = false;
  bool _includeLabRequests = false;
  bool _includeRadiologyRequests = false;

  @override
  void initState() {
    super.initState();
    _sendToPharmacy = widget.appointment.sendToPharmacy ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<EndAppointmentCubit>().loadFormData(widget.appointment);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _prescriptionNoteController.dispose();
    _labRequestNoteController.dispose();

    for (final _RadiologyRequestDraft entry in _radiologyEntries) {
      entry.dispose();
    }

    super.dispose();
  }

  Future<void> _openMedicationForm({int? index}) async {
    final EndAppointmentPrescriptionItem? initialItem = index == null
        ? null
        : _medications[index];

    final EndAppointmentPrescriptionItem? result =
        await Navigator.push<EndAppointmentPrescriptionItem>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EndAppointmentMedicationFormScreen(initialItem: initialItem),
          ),
        );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      if (index == null) {
        _medications.add(result);
      } else {
        _medications[index] = result;
      }
    });
  }

  void _removeMedication(int index) {
    setState(() {
      _medications.removeAt(index);
    });
  }

  void _addRadiologyEntry() {
    setState(() {
      _radiologyEntries.add(_RadiologyRequestDraft());
    });
  }

  void _removeRadiologyEntry(int index) {
    final _RadiologyRequestDraft entry = _radiologyEntries.removeAt(index);
    entry.dispose();
    setState(() {});
  }

  List<EndAppointmentRadiologyRequest>? _buildRadiologyRequests() {
    if (!_includeRadiologyRequests) {
      return const <EndAppointmentRadiologyRequest>[];
    }

    if (_radiologyEntries.isEmpty) {
      messages(
        context,
        'please_add_radiology_request'.tr(context),
        Colors.orange,
      );
      return null;
    }

    final List<EndAppointmentRadiologyRequest> requests =
        <EndAppointmentRadiologyRequest>[];
    final Set<int> selectedTypeIds = <int>{};

    for (final _RadiologyRequestDraft entry in _radiologyEntries) {
      if (!entry.isValid) {
        messages(
          context,
          'complete_radiology_fields'.tr(context),
          Colors.orange,
        );
        return null;
      }

      if (!selectedTypeIds.add(entry.selectedTypeId!)) {
        messages(
          context,
          'duplicate_radiology_requests'.tr(context),
          Colors.orange,
        );
        return null;
      }

      requests.add(entry.toRequestItem());
    }

    return requests;
  }

  void _submit(EndAppointmentState state) {
    if (_notesController.text.trim().isEmpty) {
      messages(context, 'please_add_general_notes'.tr(context), Colors.orange);
      return;
    }

    if (_includeLabRequests && _selectedLabTestIds.isEmpty) {
      messages(context, 'please_select_lab_test'.tr(context), Colors.orange);
      return;
    }

    final List<EndAppointmentRadiologyRequest>? radiologyRequests =
        _buildRadiologyRequests();
    if (radiologyRequests == null) {
      return;
    }

    context.read<EndAppointmentCubit>().endAppointment(
      EndAppointmentRequest(
        appointmentId: widget.appointment.id ?? 0,
        note: _notesController.text,
        prescriptionNote: _prescriptionNoteController.text,
        prescriptionItems: _medications,
        sendToPharmacy: state.hasPharmacy ? _sendToPharmacy : false,
        labRequestNote: _includeLabRequests
            ? _labRequestNoteController.text
            : null,
        labTests: _includeLabRequests
            ? _selectedLabTestIds.toList()
            : const <int>[],
        radiologyRequests: radiologyRequests,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: CustomAppbar(title: 'complete_appointment'.tr(context)),
      body: BlocConsumer<EndAppointmentCubit, EndAppointmentState>(
        listener: (context, state) {
          if (state.result != null) {
            messages(context, state.result!.message, Colors.green);
            context.read<EndAppointmentCubit>().clearSubmissionState();
            Navigator.of(context).pop(true);
          } else if (state.submitErrorMessage != null) {
            messages(context, state.submitErrorMessage!, Colors.red);
            context.read<EndAppointmentCubit>().clearSubmissionState();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _SectionTitle(
                                icon: Icons.note_alt_outlined,
                                title: 'general_notes'.tr(context),
                              ),
                              const SizedBox(height: 12),
                              _StyledTextField(
                                controller: _notesController,
                                hint: 'hint_add_clinical_notes'.tr(context),
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _SectionTitle(
                                icon: Icons.medication_outlined,
                                title: 'prescription_list'.tr(context),
                              ),
                              const SizedBox(height: 12),
                              _StyledTextField(
                                controller: _prescriptionNoteController,
                                hint: 'hint_add_prescription_note'.tr(context),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 14),
                              if (state.hasPharmacy)
                                _ToggleCard(
                                  title: 'send_to_center_pharmacy'.tr(context),
                                  subtitle: 'center_pharmacy_hint'.tr(context),
                                  value: _sendToPharmacy,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _sendToPharmacy = value;
                                    });
                                  },
                                ),
                              if (state.hasPharmacy) const SizedBox(height: 14),
                              _MedicationSummarySection(
                                medications: _medications,
                                onAdd: () => _openMedicationForm(),
                                onEdit: (int index) =>
                                    _openMedicationForm(index: index),
                                onRemove: _removeMedication,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _SectionTitle(
                                icon: Icons.science_outlined,
                                title: 'lab_tests'.tr(context),
                              ),
                              const SizedBox(height: 12),
                              _ToggleCard(
                                title: 'include_lab_requests'.tr(context),
                                subtitle: 'include_lab_requests_hint'.tr(
                                  context,
                                ),
                                value: _includeLabRequests,
                                onChanged: (bool value) {
                                  setState(() {
                                    _includeLabRequests = value;
                                    if (!value) {
                                      _selectedLabTestIds.clear();
                                      _labRequestNoteController.clear();
                                    }
                                  });
                                },
                              ),
                              if (_includeLabRequests) ...<Widget>[
                                const SizedBox(height: 14),
                                _StyledTextField(
                                  controller: _labRequestNoteController,
                                  hint: 'hint_add_lab_request_note'.tr(context),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 14),
                                if (state.isLoadingOptions)
                                  const LinearProgressIndicator(
                                    color: AppColors.primaryColors,
                                  )
                                else if (state.availableLabTests.isEmpty)
                                  _EmptyStateCard(
                                    label: 'no_lab_tests_available'.tr(context),
                                  )
                                else
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: state.availableLabTests.map((
                                      AppointmentRequestOption test,
                                    ) {
                                      final bool isSelected =
                                          _selectedLabTestIds.contains(test.id);
                                      return _SelectableChip(
                                        label: test.name,
                                        subtitle: _formatPrice(
                                          context,
                                          test.displayPrice,
                                        ),
                                        isSelected: isSelected,
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              _selectedLabTestIds.remove(
                                                test.id,
                                              );
                                            } else {
                                              _selectedLabTestIds.add(test.id);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _SectionTitle(
                                icon: Icons.medical_services_outlined,
                                title: 'radiology_requests'.tr(context),
                              ),
                              const SizedBox(height: 12),
                              _ToggleCard(
                                title: 'include_radiology_requests'.tr(context),
                                subtitle: 'include_radiology_requests_hint'.tr(
                                  context,
                                ),
                                value: _includeRadiologyRequests,
                                onChanged: (bool value) {
                                  setState(() {
                                    _includeRadiologyRequests = value;
                                    if (!value) {
                                      for (final _RadiologyRequestDraft entry
                                          in _radiologyEntries) {
                                        entry.dispose();
                                      }
                                      _radiologyEntries.clear();
                                    }
                                  });
                                },
                              ),
                              if (_includeRadiologyRequests) ...<Widget>[
                                const SizedBox(height: 14),
                                if (state.isLoadingOptions)
                                  const LinearProgressIndicator(
                                    color: AppColors.primaryColors,
                                  )
                                else if (state
                                    .availableMedicalImageTypes
                                    .isEmpty)
                                  _EmptyStateCard(
                                    label: 'no_medical_image_types_available'
                                        .tr(context),
                                  )
                                else ...<Widget>[
                                  if (_radiologyEntries.isEmpty)
                                    _EmptyStateCard(
                                      label: 'no_radiology_requests_added'.tr(
                                        context,
                                      ),
                                    ),
                                  ...List<Widget>.generate(
                                    _radiologyEntries.length,
                                    (int index) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _RadiologyRequestCard(
                                        entry: _radiologyEntries[index],
                                        index: index,
                                        options:
                                            state.availableMedicalImageTypes,
                                        onRemove: () =>
                                            _removeRadiologyEntry(index),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: _addRadiologyEntry,
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                        color: AppColors.primaryColors,
                                      ),
                                      label: Text(
                                        'add_radiology_request'.tr(context),
                                        style: const TextStyle(
                                          color: AppColors.primaryColors,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        if (state.optionsErrorMessage != null) ...<Widget>[
                          const SizedBox(height: 16),
                          _InlineMessageCard(
                            color: Colors.orange,
                            message:
                                '${'request_types_load_failed'.tr(context)}\n${state.optionsErrorMessage!}',
                            actionLabel: 'retry_loading'.tr(context),
                            onPressed: () {
                              context
                                  .read<EndAppointmentCubit>()
                                  .retryLoadingOptions(widget.appointment);
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => _submit(state),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColors,
                        disabledBackgroundColor: AppColors.primaryColors
                            .withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'submit'.tr(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String? _formatPrice(BuildContext context, double? value) {
    if (value == null) {
      return null;
    }

    final String formatted = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$formatted ${"sy".tr(context)}';
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: AppColors.primaryColors, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF233B33),
          ),
        ),
      ],
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8FAF9),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.primaryColors),
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3ECE7)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryColors,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      ),
    );
  }
}

class _MedicationSummarySection extends StatelessWidget {
  final List<EndAppointmentPrescriptionItem> medications;
  final VoidCallback onAdd;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onRemove;

  const _MedicationSummarySection({
    required this.medications,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (medications.isEmpty)
          _EmptyStateCard(label: 'no_medications_added'.tr(context))
        else
          ...List<Widget>.generate(
            medications.length,
            (int index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _MedicationSummaryCard(
                item: medications[index],
                index: index,
                onEdit: () => onEdit(index),
                onRemove: () => onRemove(index),
              ),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryColors,
            ),
            label: Text(
              'add_prescription_medication'.tr(context),
              style: const TextStyle(
                color: AppColors.primaryColors,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MedicationSummaryCard extends StatelessWidget {
  final EndAppointmentPrescriptionItem item;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _MedicationSummaryCard({
    required this.item,
    required this.index,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3ECE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${'medication'.tr(context)} ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryColors,
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              ),
            ],
          ),
          _SummaryLine(
            title: 'drug_name'.tr(context),
            value: item.medicineName,
          ),
          _SummaryLine(title: 'dose'.tr(context), value: item.dose),
          _SummaryLine(
            title: 'frequency_per_day'.tr(context),
            value: item.frequency,
          ),
          _SummaryLine(title: 'start_date'.tr(context), value: item.startDate),
          _SummaryLine(title: 'end_date'.tr(context), value: item.endDate),
          if (item.instructions.trim().isNotEmpty)
            _SummaryLine(
              title: 'special_notes'.tr(context),
              value: item.instructions,
            ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(
            context,
          ).style.copyWith(color: const Color(0xFF31453D)),
          children: <InlineSpan>[
            TextSpan(
              text: '$title: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                isSelected ? AppColors.primaryColors : const Color(0xFFFFFFFF),
                isSelected ? const Color(0xFF3F7F69) : const Color(0xFFF7FAF8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColors
                  : const Color(0xFFE1E9E4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                size: 18,
                color: isSelected ? Colors.white : AppColors.primaryColors,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF31453D),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.92)
                            : const Color(0xFF5C746B),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineMessageCard extends StatelessWidget {
  final Color color;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  const _InlineMessageCard({
    required this.color,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: color,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final String label;

  const _EmptyStateCard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE1E9E4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _RadiologyRequestCard extends StatelessWidget {
  final _RadiologyRequestDraft entry;
  final int index;
  final List<AppointmentRequestOption> options;
  final VoidCallback onRemove;

  const _RadiologyRequestCard({
    required this.entry,
    required this.index,
    required this.options,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3ECE7)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${'radiology_requests'.tr(context)} ${index + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<int>(
            initialValue: entry.selectedTypeId,
            isExpanded: true,
            borderRadius: BorderRadius.circular(16),
            decoration: InputDecoration(
              hintText: 'select_image_type'.tr(context),
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
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: AppColors.primaryColors),
              ),
            ),
            items: options.map((AppointmentRequestOption option) {
              final String? priceLabel = option.displayPrice == null
                  ? null
                  : _formatPrice(context, option.displayPrice!);

              return DropdownMenuItem<int>(
                value: option.id,
                child: Text(
                  priceLabel == null
                      ? option.name
                      : '${option.name} • $priceLabel',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (int? value) {
              entry.selectedTypeId = value;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: entry.notesController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'radiology_request_note_hint'.tr(context),
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
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: AppColors.primaryColors),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(BuildContext context, double value) {
    final String formatted = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$formatted ${"sy".tr(context)}';
  }
}

class _RadiologyRequestDraft {
  int? selectedTypeId;
  final TextEditingController notesController = TextEditingController();

  bool get isValid => selectedTypeId != null;

  EndAppointmentRadiologyRequest toRequestItem() {
    return EndAppointmentRadiologyRequest(
      typeOfMedicalImageId: selectedTypeId!,
      notes: notesController.text.trim(),
    );
  }

  void dispose() {
    notesController.dispose();
  }
}
