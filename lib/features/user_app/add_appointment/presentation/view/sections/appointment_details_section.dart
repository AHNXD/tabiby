import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';

import '../widgets/section_title.dart';

class AppointmentDetailsSection extends StatelessWidget {
  const AppointmentDetailsSection({
    super.key,
    required this.departmentType,
    required this.availableLabTests,
    required this.selectedLabTestIds,
    required this.imageType,
    required this.onImageTypeChanged,
    required this.onToggleLabTest,
    required this.selectedXrayAttachment,
    required this.selectedLabResultAttachment,
    required this.availableXrayCount,
    required this.availableLabResultCount,
    required this.onPickXray,
    required this.onPickLabResult,
    required this.onClearXray,
    required this.onClearLabResult,
  });

  final BookingDepartmentType departmentType;
  final List<LabTestOption> availableLabTests;
  final List<int> selectedLabTestIds;
  final String? imageType;
  final ValueChanged<String?> onImageTypeChanged;
  final ValueChanged<int> onToggleLabTest;
  final MedicalAttachmentItem? selectedXrayAttachment;
  final MedicalAttachmentItem? selectedLabResultAttachment;
  final int availableXrayCount;
  final int availableLabResultCount;
  final VoidCallback onPickXray;
  final VoidCallback onPickLabResult;
  final VoidCallback onClearXray;
  final VoidCallback onClearLabResult;

  static const List<String> _radiologyImageTypes = <String>[
    'X-Ray',
    'MRI',
    'CT Scan',
    'Ultrasound',
    'Mammography',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionTitle(title: '3. ${"appointment_details".tr(context)}'),
        if (departmentType.requiresImageType) _buildRadiologyFields(context),
        if (departmentType.requiresLabTests) _buildLabFields(context),
        if (departmentType.supportsMedicalAttachments)
          _buildMedicalAttachmentFields(context),
      ],
    );
  }

  Widget _buildRadiologyFields(BuildContext context) {
    final List<String> imageTypes = <String>[
      ..._radiologyImageTypes,
      if (imageType != null && !_radiologyImageTypes.contains(imageType))
        imageType!,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'radiology_booking_hint'.tr(context),
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: imageType,
          decoration: _inputDecoration(
            context,
            'select_image_type'.tr(context),
          ),
          items: imageTypes
              .map(
                (String item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onImageTypeChanged,
        ),
      ],
    );
  }

  Widget _buildLabFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'laboratory_booking_hint'.tr(context),
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableLabTests.map((LabTestOption test) {
            final bool isSelected = selectedLabTestIds.contains(test.id);
            return FilterChip(
              label: Text(test.name),
              selected: isSelected,
              onSelected: (_) => onToggleLabTest(test.id),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMedicalAttachmentFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'medical_records_hint'.tr(context),
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 12),
        _AttachmentSelectorCard(
          title: 'pick_existing_xray'.tr(context),
          emptyLabel: 'no_xray_selected'.tr(context),
          countLabel: '$availableXrayCount ${"xray_records".tr(context)}',
          selectedAttachment: selectedXrayAttachment,
          onTap: onPickXray,
          onClear: selectedXrayAttachment == null ? null : onClearXray,
        ),
        const SizedBox(height: 12),
        _AttachmentSelectorCard(
          title: 'pick_existing_lab_result'.tr(context),
          emptyLabel: 'no_lab_result_selected'.tr(context),
          countLabel: '$availableLabResultCount ${"lab_results".tr(context)}',
          selectedAttachment: selectedLabResultAttachment,
          onTap: onPickLabResult,
          onClear: selectedLabResultAttachment == null
              ? null
              : onClearLabResult,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
    );
  }
}

class _AttachmentSelectorCard extends StatelessWidget {
  const _AttachmentSelectorCard({
    required this.title,
    required this.emptyLabel,
    required this.countLabel,
    required this.selectedAttachment,
    required this.onTap,
    this.onClear,
  });

  final String title;
  final String emptyLabel;
  final String countLabel;
  final MedicalAttachmentItem? selectedAttachment;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedAttachment != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  hasSelection
                      ? Icons.check_rounded
                      : Icons.attach_file_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasSelection ? selectedAttachment!.title : emptyLabel,
                      style: TextStyle(
                        color: hasSelection
                            ? Colors.black87
                            : Colors.grey.shade600,
                        fontWeight: hasSelection
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      countLabel,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onClear != null)
                IconButton(
                  onPressed: onClear,
                  icon: Icon(Icons.close_rounded, color: Colors.grey.shade500),
                ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
