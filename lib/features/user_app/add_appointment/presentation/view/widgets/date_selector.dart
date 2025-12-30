import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../../../../core/utils/app_localizations.dart';
import '../../../data/models/days_model.dart';

class DateSelector extends StatelessWidget {
  final List<Days> days;
  final String? selectedDate;
  final ValueChanged<String> onSelect;

  const DateSelector({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final dayData = days[index];
          DateTime parsedDate = DateTime.parse(dayData.date!);
          final isSelected = selectedDate == dayData.date;

          return GestureDetector(
            onTap: () {
              if (dayData.date != null) {
                onSelect(dayData.date!);
              }
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColors
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat(
                      'EEEE',
                    ).format(parsedDate).toLowerCase().tr(context),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd').format(parsedDate),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
