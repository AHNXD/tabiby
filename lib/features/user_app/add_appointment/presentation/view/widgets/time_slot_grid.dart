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
      children: [
        if (periods.morning?.isNotEmpty ?? false)
          _buildTimeGroup("morning".tr(context), periods.morning!, "morning"),
        if (periods.afternoon?.isNotEmpty ?? false)
          _buildTimeGroup(
            "afternoon".tr(context),
            periods.afternoon!,
            "afternoon",
          ),
        if (periods.evening?.isNotEmpty ?? false)
          _buildTimeGroup("evening".tr(context), periods.evening!, "evening"),
      ],
    );
  }

  Widget _buildTimeGroup(
    String label,
    List<TimeSlot> slots,
    String categoryKey,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: slots.map((slot) {
            final isSelected = selectedSlot == slot.time;
            return ChoiceChip(
              disabledColor: Colors.grey.shade100,
              label: Text(slot.time!),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  onSelect(slot.time!, categoryKey);
                }
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: AppColors.primaryColors,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}
