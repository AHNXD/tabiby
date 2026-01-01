import 'package:flutter/material.dart';
import '../../../../../../core/utils/app_localizations.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../data/models/times_model.dart';

class TimeSlotGrid extends StatelessWidget {
  final Periods periods;
  final String? selectedSlot;
  final Function(String time, String category) onSelect;

  const TimeSlotGrid({
    super.key,
    required this.periods,
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (periods.morning?.isNotEmpty ?? false)
          _buildTimeGroup(
            context,
            "morning".tr(context),
            periods.morning!,
            "morning",
          ),

        if (periods.afternoon?.isNotEmpty ?? false)
          _buildTimeGroup(
            context,
            "afternoon".tr(context),
            periods.afternoon!,
            "afternoon",
          ),

        if (periods.evening?.isNotEmpty ?? false)
          _buildTimeGroup(
            context,
            "evening".tr(context),
            periods.evening!,
            "evening",
          ),
      ],
    );
  }

  Widget _buildTimeGroup(
    BuildContext context,
    String label,
    List<TimeSlot> slots,
    String categoryKey,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Critical for section title
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                Icon(
                  _getIconForCategory(categoryKey),
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Time Chips
          Wrap(
            spacing: 12.0, // Horizontal space between chips
            runSpacing: 12.0, // Vertical space between lines
            alignment:
                WrapAlignment.start, // Forces items to start from left edge
            children: slots.map((slot) {
              final isSelected = selectedSlot == slot.time;
              return _buildTimeChip(slot.time!, isSelected, categoryKey);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected, String categoryKey) {
    return InkWell(
      onTap: () => onSelect(time, categoryKey),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColors : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColors : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColors.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String key) {
    switch (key.toLowerCase()) {
      case 'morning':
        return Icons.wb_sunny_outlined;
      case 'afternoon':
        return Icons.wb_twilight_rounded;
      case 'evening':
        return Icons.nights_stay_outlined;
      default:
        return Icons.access_time;
    }
  }
}
