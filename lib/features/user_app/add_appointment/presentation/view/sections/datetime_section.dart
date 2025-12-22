import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/days_model.dart';

import '../../../data/models/times_model.dart';
import '../widgets/date_selector.dart';
import '../widgets/section_title.dart';
import '../widgets/time_slot_grid.dart';

class DateTimeSection extends StatelessWidget {
  final List<Days> days;
  final String? selectedDate;
  final ValueChanged<String> onSelectDate;

  final bool isLoadingTimes;
  final Periods? periods;
  final String? selectedTimeSlot;
  final Function(String time, String category) onSelectTimeSlot;

  const DateTimeSection({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onSelectDate,
    required this.isLoadingTimes,
    this.periods,
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
          days: days,
          selectedDate: selectedDate,
          onSelect: onSelectDate,
        ),
        const SizedBox(height: 20),
        if (isLoadingTimes)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (periods != null)
          TimeSlotGrid(
            periods: periods!,
            selectedSlot: selectedTimeSlot,
            onSelect: onSelectTimeSlot,
          ),
      ],
    );
  }
}
