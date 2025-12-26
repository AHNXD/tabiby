import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class FiltersWidget extends StatelessWidget {
  final String selectedDate;
  final String selectedCenter;
  final ValueChanged<String?> onDateChanged;
  final ValueChanged<String?> onCenterChanged;

  const FiltersWidget({
    super.key,
    required this.selectedDate,
    required this.selectedCenter,
    required this.onDateChanged,
    required this.onCenterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],

      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),

        borderSide: BorderSide(color: AppColors.primaryColors, width: 2.0),
      ),
    );

    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: inputDecoration.copyWith(
              prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
              labelText: 'date'.tr(context),
            ),
            isExpanded: true,
            value: selectedDate,

            borderRadius: BorderRadius.circular(12.0),
            elevation: 4,
            items: ['today', 'tomorrow', 'this_week']
                .map(
                  (label) => DropdownMenuItem(
                    value: label,
                    child: Text(label.tr(context)),
                  ),
                )
                .toList(),
            onChanged: onDateChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: inputDecoration.copyWith(
              prefixIcon: const Icon(Icons.location_on_outlined, size: 20),
              labelText: 'center'.tr(context),
            ),
            isExpanded: true,
            value: selectedCenter,

            borderRadius: BorderRadius.circular(12.0),
            elevation: 4,
            items: ['all', 'Downtown Medical Center', 'Uptown Clinic']
                .map(
                  (label) => DropdownMenuItem(value: label, child: Text(label)),
                )
                .toList(),
            onChanged: onCenterChanged,
          ),
        ),
      ],
    );
  }
}
