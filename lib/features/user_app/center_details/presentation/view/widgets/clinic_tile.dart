import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctors/presentation/view/all_doctors_screen.dart';
import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';
import '../../../data/models/centers_model.dart' show Clinics;
import 'package:tabiby/core/utils/colors.dart'; // Ensure you import your colors

class ClinicTile extends StatelessWidget {
  final int centerID;
  final Clinics clinic;

  const ClinicTile({super.key, required this.centerID, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.pushNamed(
              context,
              AllDoctorsScreen.routeName,
              arguments: {'centerID': centerID, 'specialtyID': clinic.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // 1. Image with border and shadow
                ClipOval(
                  child: CustomImageWidget(
                    imageUrl: clinic.image,
                    placeholderAsset: AssetsData.appIcon,
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 16),

                // 2. Title Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clinic.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),
                      Text(
                        "view_doctors".tr(context),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // 3. Forward Arrow Button (Glassmorphism style)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.primaryColors,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
