import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';

import '../widgets/section_title.dart';

class AppointmentDetailsSection extends StatelessWidget {
  const AppointmentDetailsSection({
    super.key,
    required this.departmentType,
    required this.availableLabTests,
    required this.selectedLabTestIds,
    required this.availableMedicalImageTypes,
    required this.selectedMedicalImageTypeId,
    required this.onMedicalImageTypeChanged,
    required this.onToggleLabTest,
    required this.selectedMedicalAttachments,
    required this.availableMedicalAttachments,
    required this.onPickMedicalRecords,
    required this.onClearMedicalRecords,
  });

  final BookingDepartmentType departmentType;
  final List<LabTestOption> availableLabTests;
  final List<int> selectedLabTestIds;
  final List<MedicalImageTypeOption> availableMedicalImageTypes;
  final int? selectedMedicalImageTypeId;
  final ValueChanged<int?> onMedicalImageTypeChanged;
  final ValueChanged<int> onToggleLabTest;
  final List<MedicalAttachmentItem> selectedMedicalAttachments;
  final List<MedicalAttachmentItem> availableMedicalAttachments;
  final VoidCallback onPickMedicalRecords;
  final VoidCallback onClearMedicalRecords;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'radiology_booking_hint'.tr(context),
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 10),
        ...availableMedicalImageTypes.map((MedicalImageTypeOption item) {
          final bool isSelected = selectedMedicalImageTypeId == item.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChoiceTile(
              title: item.name,
              isSelected: isSelected,
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColors
                        : const Color(0xFFB8C8C0),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.primaryColors
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),
              onTap: () => onMedicalImageTypeChanged(item.id),
            ),
          );
        }),
        if (availableMedicalImageTypes.isEmpty)
          _EmptySelectionCard(label: 'select_image_type'.tr(context)),
        const SizedBox(height: 14),
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
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableLabTests.map((LabTestOption test) {
            final bool isSelected = selectedLabTestIds.contains(test.id);
            return _LabTestChip(
              label: test.name,
              isSelected: isSelected,
              onTap: () => onToggleLabTest(test.id),
            );
          }).toList(),
        ),
        if (availableLabTests.isEmpty)
          _EmptySelectionCard(label: 'please_select_lab_test'.tr(context)),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildMedicalAttachmentFields(BuildContext context) {
    final bool hasSelection = selectedMedicalAttachments.isNotEmpty;
    final String selectedLabel = hasSelection
        ? selectedMedicalAttachments
              .take(2)
              .map((MedicalAttachmentItem item) => item.title)
              .join(', ')
        : 'no_medical_records_selected'.tr(context);

    final String countLabel =
        '${availableMedicalAttachments.length} ${"available_medical_records".tr(context)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'medical_records_hint'.tr(context),
          style: TextStyle(color: Colors.grey.shade600, height: 1.4),
        ),
        const SizedBox(height: 12),
        _AttachmentSelectorCard(
          title: 'pick_medical_records'.tr(context),
          emptyLabel: 'no_medical_records_selected'.tr(context),
          countLabel: countLabel,
          selectedLabel: selectedLabel,
          selectedCount: selectedMedicalAttachments.length,
          hasSelection: hasSelection,
          onTap: onPickMedicalRecords,
          onClear: hasSelection ? onClearMedicalRecords : null,
        ),
      ],
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.leading,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final Widget leading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColors.withValues(alpha: 0.08)
                : const Color(0xFFF8FBF9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColors.withValues(alpha: 0.35)
                  : const Color(0xFFE1E9E4),
            ),
          ),
          child: Row(
            children: <Widget>[
              if (!isRtl) ...<Widget>[leading, const SizedBox(width: 12)],
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isRtl ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF21493B)
                        : Colors.black87,
                  ),
                ),
              ),
              if (isRtl) ...<Widget>[const SizedBox(width: 12), leading],
            ],
          ),
        ),
      ),
    );
  }
}

class _LabTestChip extends StatelessWidget {
  const _LabTestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

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
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: isSelected
                    ? AppColors.primaryColors.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFFE9F0EC),
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.add_rounded,
                  size: 14,
                  color: isSelected ? Colors.white : AppColors.primaryColors,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF31453D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySelectionCard extends StatelessWidget {
  const _EmptySelectionCard({required this.label});

  final String label;

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

class _AttachmentSelectorCard extends StatelessWidget {
  const _AttachmentSelectorCard({
    required this.title,
    required this.emptyLabel,
    required this.countLabel,
    required this.selectedLabel,
    required this.selectedCount,
    required this.hasSelection,
    required this.onTap,
    this.onClear,
  });

  final String title;
  final String emptyLabel;
  final String countLabel;
  final String selectedLabel;
  final int selectedCount;
  final bool hasSelection;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
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
                      ? Icons.checklist_rounded
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
                      hasSelection ? selectedLabel : emptyLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      hasSelection
                          ? '$selectedCount ${"selected_medical_records".tr(context)}'
                          : countLabel,
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
