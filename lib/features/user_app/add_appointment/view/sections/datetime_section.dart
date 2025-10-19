import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../widgets/date_selector.dart';
import '../widgets/section_title.dart';
import '../widgets/time_slot_grid.dart';

class DateTimeSection extends StatelessWidget {
  final List<Map<String, String>> dates;
  final int selectedDateIndex;
  final ValueChanged<int> onSelectDate;

  final Map<String, List<String>> timeSlots;
  final String? selectedTimeSlot;
  final ValueChanged<String?> onSelectTimeSlot;

  const DateTimeSection({
    super.key,
    required this.dates,
    required this.selectedDateIndex,
    required this.onSelectDate,
    required this.timeSlots,
    required this.selectedTimeSlot,
    required this.onSelectTimeSlot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: '2. ${"select_date_and_time".tr(context)}'),
        const SizedBox(height: 12),
        DateSelector(
          dates: dates,
          selectedIndex: selectedDateIndex,
          onSelect: onSelectDate,
        ),
        const SizedBox(height: 20),
        TimeSlotGrid(
          timeSlots: timeSlots,
          selectedSlot: selectedTimeSlot,
          onSelect: onSelectTimeSlot,
        ),
      ],
    );
  }
}
