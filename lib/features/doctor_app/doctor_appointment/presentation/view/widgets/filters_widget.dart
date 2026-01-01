import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class FiltersWidget extends StatelessWidget {
  final String selectedDate;
  final String selectedCenter;
  final ValueChanged<String?> onDateChanged;
  final ValueChanged<String?> onCenterChanged;
  final List<dynamic> centers;

  const FiltersWidget({
    super.key,
    required this.selectedDate,
    required this.selectedCenter,
    required this.onDateChanged,
    required this.onCenterChanged,
    required this.centers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date Dropdown
        Expanded(
          child: _buildStyledDropdown(
            context,
            value: selectedDate,
            items: ['today', 'tomorrow', 'this_week']
                .map(
                  (label) => DropdownMenuItem(
                    value: label,
                    child: Text(
                      label.tr(context),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: onDateChanged,
            icon: Icons.calendar_month_rounded,
            label: 'date'.tr(context),
          ),
        ),

        const SizedBox(width: 12),

        // Center Dropdown
        Expanded(
          child: _buildStyledDropdown(
            context,
            value: selectedCenter,
            items: [
              DropdownMenuItem(
                value: 'all',
                child: Text(
                  'all'.tr(context),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              ...centers.map(
                (center) => DropdownMenuItem(
                  value: center.id.toString(),
                  child: Text(
                    center.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
            onChanged: onCenterChanged,
            icon: Icons.location_on_rounded,
            label: 'center'.tr(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledDropdown(
    BuildContext context, {
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        iconSize: 20,
        isExpanded: true,
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: 'cocon-next-arabic',
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: AppColors.primaryColors.withOpacity(0.7),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppColors.primaryColors.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
