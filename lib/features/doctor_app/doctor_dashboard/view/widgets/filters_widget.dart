import 'package:flutter/material.dart';

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
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
              labelText: 'Date',
            ),
            isExpanded: true,
            value: selectedDate,
            items: ['Today', 'Tomorrow', 'This Week']
                .map((label) =>
                    DropdownMenuItem(value: label, child: Text(label)))
                .toList(),
            onChanged: onDateChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined, size: 20),
              labelText: 'Center',
            ),
            isExpanded: true,
            value: selectedCenter,
            items: ['All', 'Downtown Medical Center', 'Uptown Clinic']
                .map((label) =>
                    DropdownMenuItem(value: label, child: Text(label)))
                .toList(),
            onChanged: onCenterChanged,
          ),
        ),
      ],
    );
  }
}
