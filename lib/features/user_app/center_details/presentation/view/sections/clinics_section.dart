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
        SizedBox(height: 30),
        Text(
          'clinics_and_departments'.tr(context),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColors,
          ),
        ),
        Divider(height: 10, thickness: 1),
        SizedBox(height: 20),
        ListView.builder(
          itemCount: clinics.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return ClinicTile(
              centerID: centerID,
              clinicID: clinics[index].id ?? 0,
              clinicName: clinics[index].name ?? '',
            );
          },
        ),
      ],
    );
  }
}
