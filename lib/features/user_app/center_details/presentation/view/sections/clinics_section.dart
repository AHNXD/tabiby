import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/center_details/data/models/centers_model.dart';
import '../widgets/clinic_tile.dart';

class ClinicsSection extends StatelessWidget {
  final int centerID;
  final List<Clinics> clinics;
  const ClinicsSection({
    super.key,
    required this.clinics,
    required this.centerID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'clinics_and_departments'.tr(context),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2C28),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'center_details'.tr(context),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${clinics.length}',
                  style: const TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 42,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          itemCount: clinics.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ClinicTile(centerID: centerID, clinic: clinics[index]);
          },
        ),
      ],
    );
  }
}
