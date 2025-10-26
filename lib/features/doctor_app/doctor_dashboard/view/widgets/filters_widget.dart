import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart'; // Assuming AppColors is in here

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
    // --- Define a reusable stylish InputDecoration ---
    final inputDecoration = InputDecoration(
      // 1. Give it a subtle background color
      filled: true,
      fillColor: Colors.grey[100],

      // 2. Add padding inside the field
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),

      // 3. Create the main border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none, // No border by default
      ),

      // 4. Style the border when the field is enabled (not focused)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!), // Subtle border
      ),

      // 5. Style the border when the field is focused (tapped)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),

        borderSide: BorderSide(color: AppColors.primaryColors, width: 2.0),
      ),
    );
    // --- End of style definition ---

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
            items:
                [
                      'today'.tr(context),
                      'tomorrow'.tr(context),
                      'this_week'.tr(context),
                    ]
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
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
            items:
                ['all'.tr(context), 'Downtown Medical Center', 'Uptown Clinic']
                    .map(
                      (label) =>
                          DropdownMenuItem(value: label, child: Text(label)),
                    )
                    .toList(),
            onChanged: onCenterChanged,
          ),
        ),
      ],
    );
  }
}
