import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctor_details/data/models/doctor_model.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import 'sections/affiliated_centers_section.dart';
import 'sections/biography_section.dart';
import 'widgets/booking_button.dart';
import 'widgets/doctor_header.dart';

class DoctorDetailsScreen extends StatelessWidget {
  static const String routeName = "/doctor_details";
  final Doctor doctor;
  final List<Map<String, dynamic>> centers;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,

    this.centers = const [
      {
        'centerName': 'Wellness Clinic',
        'price': '\$150',
        'availableDays': ["Mon", "Wed", "Fri", "Sun"],
      },
      {
        'centerName': 'City Health Center',
        'price': '\$120',
        'availableDays': ["Tue", "Thu"],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "doctor_details".tr(context)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  DoctorHeader(
                    name: doctor.name ?? '',
                    specialty: doctor.specialty?.name ?? '',
                    experience:
                        '${doctor.yearsOfExperience ?? 0} ${"years_of_experience".tr(context)}',
                    imageUrl: doctor.img,
                    rate: doctor.rate ?? 0,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                      const SizedBox(width: 4),
                      Text(
                        (doctor.yearsOfExperience ?? 0).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  // Rating Section
                  const SizedBox(height: 24),
                  // Biography Section
                  BiographySection(biography: doctor.bio ?? "There is no bio"),
                  const SizedBox(height: 24),
                  // Affiliated Centers Section
                  AffiliatedCentersSection(centers: centers),
                ],
              ),
            ),
          ),
          const BookingButton(),
        ],
      ),
    );
  }
}
