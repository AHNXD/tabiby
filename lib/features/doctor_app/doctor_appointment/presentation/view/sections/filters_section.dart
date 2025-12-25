import 'package:flutter/material.dart';
import '../widgets/filters_widget.dart';

class FiltersSection extends StatelessWidget {
  final String selectedDate;
  final String selectedCenter;
  final ValueChanged<String?> onDateChanged;
  final ValueChanged<String?> onCenterChanged;

  const FiltersSection({
    super.key,
    required this.selectedDate,
    required this.selectedCenter,
    required this.onDateChanged,
    required this.onCenterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FiltersWidget(
      selectedDate: selectedDate,
      selectedCenter: selectedCenter,
      onDateChanged: onDateChanged,
      onCenterChanged: onCenterChanged,
    );
  }
}
