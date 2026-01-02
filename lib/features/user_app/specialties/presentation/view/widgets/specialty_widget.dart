import 'package:flutter/material.dart';

import '../../../../../../core/widgets/custom_image_widget.dart';
import '../../../../doctors/presentation/view/all_doctors_screen.dart';
import '../../../data/models/specialties_model.dart';

class SpecialtyWidget extends StatelessWidget {
  const SpecialtyWidget({super.key, required this.specialty});

  final SpecializationModel specialty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AllDoctorsScreen.routeName,
        arguments: {'specialtyID': specialty.id},
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 1. The Icon Container
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20), // Soft squircle shape
              border: Border.all(
                color: Colors.grey.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), // Much softer shadow
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CustomImageWidget(
              imageUrl: specialty.img,
              // Assuming this is a local asset path, otherwise ensure it's in AssetsData
              placeholderAsset: 'assets/icons/appIcon.png',
              height: 60,
              width: 60,
              fit: BoxFit.contain, // Contain usually looks better for icons
            ),
          ),

          const SizedBox(height: 6),

          // 2. The Text
          // Using Flexible to prevent overflow if the name is long
          SizedBox(
            width: 80, // Constrain width to keep text centered under icon

            child: Text(
              specialty.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w600, // Slightly bolder for readability
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
