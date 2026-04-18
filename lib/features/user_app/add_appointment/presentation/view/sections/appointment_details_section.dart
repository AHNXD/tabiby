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
          style: TextStyle(color: AppColors.grey600Color, height: 1.4),
        ),
        const SizedBox(height: 10),
        ...availableMedicalImageTypes.map((MedicalImageTypeOption item) {
          final bool isSelected = selectedMedicalImageTypeId == item.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ChoiceTile(
              title: item.name,
              priceLabel: _buildPriceLabel(
                context,
                selectedCenterPrice: item.selectedCenterPrice,
                fallbackPrice: item.price,
              ),
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
                        : AppColors.sageBorderTintColor,
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
                          : AppColors.transparentColor,
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
    final double? selectedLabTestsTotal = _selectedLabTestsTotal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'laboratory_booking_hint'.tr(context),
          style: TextStyle(color: AppColors.grey600Color, height: 1.4),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableLabTests.map((LabTestOption test) {
            final bool isSelected = selectedLabTestIds.contains(test.id);
            return _LabTestChip(
              label: test.name,
              priceLabel: _buildPriceLabel(
                context,
                selectedCenterPrice: test.selectedCenterPrice,
                fallbackPrice: test.price,
              ),
              isSelected: isSelected,
              onTap: () => onToggleLabTest(test.id),
            );
          }).toList(),
        ),
        if (selectedLabTestsTotal != null) ...<Widget>[
          const SizedBox(height: 12),
          _SelectionTotalCard(
            label: 'selected_lab_tests_total'.tr(context),
            value: _formatPrice(context, price: selectedLabTestsTotal)!,
          ),
        ],
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
          style: TextStyle(color: AppColors.grey600Color, height: 1.4),
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

  String? _buildPriceLabel(
    BuildContext context, {
    required double? selectedCenterPrice,
    required double? fallbackPrice,
  }) {
    return _formatPrice(context, price: selectedCenterPrice ?? fallbackPrice);
  }

  String? _formatPrice(BuildContext context, {required double? price}) {
    if (price == null) {
      return null;
    }

    final String formattedPrice = price == price.roundToDouble()
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(2);

    return '$formattedPrice ${"sy".tr(context)}';
  }

  double? _selectedLabTestsTotal() {
    double total = 0;
    bool hasPricedSelection = false;

    for (final LabTestOption test in availableLabTests) {
      if (!selectedLabTestIds.contains(test.id)) {
        continue;
      }

      final double? price = test.selectedCenterPrice ?? test.price;
      if (price == null) {
        continue;
      }

      total += price;
      hasPricedSelection = true;
    }

    return hasPricedSelection ? total : null;
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.title,
    required this.leading,
    required this.isSelected,
    required this.onTap,
    this.priceLabel,
  });

  final String title;
  final Widget leading;
  final bool isSelected;
  final VoidCallback onTap;
  final String? priceLabel;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColors.withValues(alpha: 0.08)
                : AppColors.softSurfaceAltColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColors.withValues(alpha: 0.35)
                  : AppColors.sageBorderColor,
            ),
          ),
          child: Row(
            children: <Widget>[
              if (!isRtl) ...<Widget>[leading, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: isRtl
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected
                            ? AppColors.forestTextColor
                            : AppColors.black87Color,
                      ),
                    ),
                    if (priceLabel != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColors.withValues(alpha: 0.14)
                              : AppColors.sageTintSurfaceColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          priceLabel!,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.forestTextColor
                                : AppColors.forestBodyColor,
                          ),
                        ),
                      ),
                    ],
                  ],
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
    this.priceLabel,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? priceLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                isSelected ? AppColors.primaryColors : AppColors.whiteColor,
                isSelected
                    ? AppColors.forestAccentColor
                    : AppColors.lighterSurfaceColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColors
                  : AppColors.sageBorderColor,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: isSelected
                    ? AppColors.primaryColors.withValues(alpha: 0.2)
                    : AppColors.blackColor.withValues(alpha: 0.03),
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
                      ? AppColors.whiteColor.withValues(alpha: 0.2)
                      : AppColors.sageSurfaceMutedColor,
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.add_rounded,
                  size: 14,
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.primaryColors,
                ),
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
                          ? AppColors.whiteColor
                          : AppColors.forestTextSoftColor,
                    ),
                  ),
                  if (priceLabel != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      priceLabel!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.whiteColor.withValues(alpha: 0.92)
                            : AppColors.forestMutedTextColor,
                      ),
                    ),
                  ],
                ],
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
        color: AppColors.softSurfaceAltColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sageBorderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.grey600Color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SelectionTotalCard extends StatelessWidget {
  const _SelectionTotalCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primaryColors.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.forestTextColor,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.forestTextColor,
            ),
          ),
        ],
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
      color: AppColors.transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.grey300Color),
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
                            ? AppColors.black87Color
                            : AppColors.grey600Color,
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
                        color: AppColors.grey500Color,
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
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColors.grey500Color,
                  ),
                ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.grey400Color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
