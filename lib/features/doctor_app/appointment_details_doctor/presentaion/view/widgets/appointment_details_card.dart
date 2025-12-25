import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'appointment_detail_row.dart';

class AppointmentDetailsCard extends StatelessWidget {
  const AppointmentDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            AppointmentDetailRow(
              icon: Icons.person_outline,
              label: 'gender'.tr(context),
              value: 'female'.tr(context),
            ),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(
              icon: Icons.cake_outlined,
              label: 'age'.tr(context),
              value: '34 ${"years".tr(context)}',
            ),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(
              icon: Icons.height,
              label: 'height'.tr(context),
              value: '168 ${"cm".tr(context)}',
            ),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(
              icon: Icons.monitor_weight_outlined,
              label: 'weight',
              value: '65 ${"kg".tr(context)}',
            ),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(
              icon: Icons.smoking_rooms,
              label: 'smoker'.tr(context),
              value: 'no'.tr(context),
            ),
            Divider(height: 1, indent: 16, endIndent: 16),
            AppointmentDetailRow(
              icon: Icons.favorite_border,
              label: 'marital_status'.tr(context),
              value: 'married'.tr(context),
            ),
          ],
        ),
      ),
    );
  }
}
