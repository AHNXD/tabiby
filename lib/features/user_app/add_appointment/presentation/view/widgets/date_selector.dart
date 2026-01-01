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
      height: 90, // Increased height for better spacing
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 65,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColors : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColors
                      : Colors.grey.shade200,
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
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. Month (e.g., Jan)
                  Text(
                    DateFormat(
                      'MMM',
                    ).format(parsedDate).toUpperCase().tr(context),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade500,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // 2. Day Number (e.g., 12)
                  Text(
                    DateFormat('dd').format(parsedDate),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    DateFormat(
                      'EEEE',
                    ).format(parsedDate).toLowerCase().tr(context),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
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
