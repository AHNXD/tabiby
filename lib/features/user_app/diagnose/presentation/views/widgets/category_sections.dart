import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

import 'body_part_catalog.dart';

class CategoryInstructionCard extends StatelessWidget {
  const CategoryInstructionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        'select_body_part_instruction'.tr(context),
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CategorySideToggle extends StatelessWidget {
  const CategorySideToggle({
    super.key,
    required this.currentSide,
    required this.onSideChanged,
  });

  final BodySide currentSide;
  final ValueChanged<BodySide> onSideChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CategorySideButton(
            label: 'front_side'.tr(context),
            selected: currentSide == BodySide.front,
            onTap: () => onSideChanged(BodySide.front),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CategorySideButton(
            label: 'back_side'.tr(context),
            selected: currentSide == BodySide.back,
            onTap: () => onSideChanged(BodySide.back),
          ),
        ),
      ],
    );
  }
}

class CategoryBodyPartsGrid extends StatelessWidget {
  const CategoryBodyPartsGrid({
    super.key,
    required this.parts,
    required this.selectedPartKey,
    required this.onPartTap,
  });

  final List<BodyPartDescriptor> parts;
  final String? selectedPartKey;
  final ValueChanged<BodyPartDescriptor> onPartTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: parts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, index) {
        final part = parts[index];
        final bool isSelected = part.id == selectedPartKey;

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => onPartTap(part),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColors
                    : Colors.grey.shade200,
                width: isSelected ? 1.8 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  part.icon,
                  color: isSelected
                      ? AppColors.primaryColors
                      : Colors.grey.shade700,
                  size: 26,
                ),
                const SizedBox(height: 8),
                Text(
                  part.labelKey.tr(context),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.primaryColors
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CategorySelectedPartBanner extends StatelessWidget {
  const CategorySelectedPartBanner({super.key, required this.selectedPart});

  final BodyPartDescriptor? selectedPart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: selectedPart == null
                ? Colors.grey.shade400
                : AppColors.primaryColors,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              selectedPart == null
                  ? 'no_body_part_selected'.tr(context)
                  : selectedPart!.labelKey.tr(context),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selectedPart == null
                    ? Colors.grey.shade500
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySideButton extends StatelessWidget {
  const CategorySideButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? AppColors.primaryColors.withValues(alpha: 0.14)
              : Colors.white,
          border: Border.all(
            color: selected ? AppColors.primaryColors : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? AppColors.primaryColors : Colors.grey.shade700,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
