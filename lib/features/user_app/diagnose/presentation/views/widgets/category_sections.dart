import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

import 'body_part_catalog.dart';

class CategoryHeroCard extends StatelessWidget {
  const CategoryHeroCard({super.key, required this.selectedPart});

  final BodyPartDescriptor? selectedPart;

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedPart != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.health_and_safety_outlined,
                        color: AppColors.primaryColors,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    _CategoryHeroBadge(
                      isSelected: hasSelection,
                      text: hasSelection
                          ? selectedPart!.labelKey.tr(context)
                          : 'no_body_part_selected'.tr(context),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'diagnose_category'.tr(context),
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'select_body_part_instruction'.tr(context),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: CategorySideButton(
              label: 'front_side'.tr(context),
              icon: Icons.accessibility_new_rounded,
              selected: currentSide == BodySide.front,
              onTap: () => onSideChanged(BodySide.front),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: CategorySideButton(
              label: 'back_side'.tr(context),
              icon: Icons.accessibility_rounded,
              selected: currentSide == BodySide.back,
              onTap: () => onSideChanged(BodySide.back),
            ),
          ),
        ],
      ),
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
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final BodyPartDescriptor part = parts[index];
        final bool isSelected = part.id == selectedPartKey;

        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onPartTap(part),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [const Color(0xFFEFF8F5), const Color(0xFFF9FCFB)]
                    : [Colors.white, const Color(0xFFF9FAFB)],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColors.withValues(alpha: 0.8)
                    : Colors.grey.shade200,
                width: isSelected ? 1.8 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primaryColors.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color:
                            (isSelected
                                    ? AppColors.primaryColors
                                    : Colors.grey.shade500)
                                .withValues(alpha: isSelected ? 0.14 : 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        part.icon,
                        color: isSelected
                            ? AppColors.primaryColors
                            : Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColors.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.primaryColors.withValues(
                              alpha: 0.14,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColors,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'diagnose_tile_selected'.tr(context),
                              style: const TextStyle(
                                color: AppColors.primaryColors,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: 26,
                  height: 3,
                  decoration: BoxDecoration(
                    color:
                        (isSelected
                                ? AppColors.primaryColors
                                : Colors.grey.shade400)
                            .withValues(alpha: 0.32),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const Spacer(),
                Text(
                  part.labelKey.tr(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF1F2C28)
                        : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isSelected
                      ? 'diagnose_tile_selected'.tr(context)
                      : 'diagnose_tile_tap'.tr(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColors
                        : Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }, childCount: parts.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.08,
      ),
    );
  }
}

class CategorySideButton extends StatelessWidget {
  const CategorySideButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: selected ? Colors.white : Colors.transparent,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.primaryColors : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? AppColors.primaryColors
                      : Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryHeroBadge extends StatelessWidget {
  const _CategoryHeroBadge({required this.isSelected, required this.text});

  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: (isSelected ? AppColors.primaryColors : Colors.grey.shade400)
                .withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColors
                    : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primaryColors
                      : Colors.grey.shade600,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
