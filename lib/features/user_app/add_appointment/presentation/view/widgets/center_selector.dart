import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import '../../../../../../core/utils/app_localizations.dart';
import '../../../data/models/centers_appointment_model.dart';

class CenterSelector extends StatelessWidget {
  final List<Centers> centers;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  const CenterSelector({
    super.key,
    required this.centers,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125, // Slightly increased height for better spacing
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemCount: centers.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final center = centers[index];
          final isSelected = selectedId == center.id;

          return GestureDetector(
            onTap: () {
              if (center.id != null) {
                onSelect(center.id!);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 260,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // White background for unselected, very light primary tint for selected
                color: isSelected
                    ? AppColors.primaryColors.withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColors
                      : Colors.grey.shade200,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primaryColors.withOpacity(0.15)
                        : Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header Row: Name + Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          center.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.primaryColors
                                : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Custom Checkbox Circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primaryColors
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryColors
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // 2. Address with Icon
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          center.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 3. Price Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColors
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${center.price} ${"sy".tr(context)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
