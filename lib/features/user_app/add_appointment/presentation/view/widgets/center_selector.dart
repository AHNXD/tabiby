import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../../../../core/utils/app_localizations.dart';
import '../../../data/models/centers_appointment_model.dart';

class CenterSelector extends StatelessWidget {
  final List<Centers> centers;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  const CenterSelector({
    super.key,
    required this.centers,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: centers.length,
        itemBuilder: (context, index) {
          final center = centers[index];
          final isSelected = selectedId == center.id;
          return GestureDetector(
            onTap: () {
              if (center.id != null) {
                onSelect(center.id!);
              }
            },
            child: Card(
              color: isSelected
                  ? AppColors.primaryColors
                  : Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 250,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      center.address ?? '',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${center.price} ${"sy".tr(context)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isSelected
                            ? Colors.white
                            : AppColors.primaryColors,
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
