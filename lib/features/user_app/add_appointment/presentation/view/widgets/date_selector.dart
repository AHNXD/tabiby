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
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final dayData = days[index];
          DateTime parsedDate = DateTime.parse(dayData.date!);
          final isSelected = selectedDate == dayData.date;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GestureDetector(
              onTap: () {
                if (dayData.date != null) {
                  onSelect(dayData.date!);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      isSelected
                          ? AppColors.primaryColors
                          : AppColors.whiteColor,
                      isSelected
                          ? AppColors.forestAccentColor
                          : AppColors.lightSurfaceColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColors
                        : AppColors.sageSurfaceAltColor,
                    width: 1.5,
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isSelected
                          ? AppColors.primaryColors.withValues(alpha: 0.24)
                          : AppColors.blackColor.withValues(alpha: 0.04),
                      blurRadius: isSelected ? 16 : 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat(
                        'MMM',
                      ).format(parsedDate).toUpperCase().tr(context),
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.whiteColor.withValues(alpha: 0.8)
                            : AppColors.grey500Color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      DateFormat('dd').format(parsedDate),
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.black87Color,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 4),

                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          DateFormat(
                            'EEEE',
                          ).format(parsedDate).toLowerCase().tr(context),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.whiteColor
                                : AppColors.grey600Color,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
