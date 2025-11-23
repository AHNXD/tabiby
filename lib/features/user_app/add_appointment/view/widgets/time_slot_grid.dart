import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class TimeSlotGrid extends StatelessWidget {
  final Map<String, List<String>> timeSlots;
  final String? selectedSlot;
  final ValueChanged<String?> onSelect;

  const TimeSlotGrid({
    super.key,
    required this.timeSlots,
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: timeSlots.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: entry.value.map((time) {
                final isSelected = selectedSlot == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (selected) => onSelect(selected ? time : null),
                  selectedColor: AppColors.primaryColors,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.grey.shade100,
                  showCheckmark: false,
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}
