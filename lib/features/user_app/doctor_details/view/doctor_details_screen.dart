import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctor_details/data/models/doctor_model.dart';

import '../../../../core/widgets/custom_appbar.dart';
import 'sections/affiliated_centers_section.dart';
import 'sections/biography_section.dart';
import 'widgets/booking_button.dart';
import 'widgets/doctor_header.dart';
import 'widgets/doctor_rating.dart';

class DoctorDetailsScreen extends StatelessWidget {
  static const String routeName = "/doctor_details";
  final Doctors doctor;
  final String biography;
  final List<Map<String, dynamic>> centers;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,

    this.biography =
        'Dr. Moustafa Karam is a distinguished dermatologist with over 15 years of experience in cosmetic and medical dermatology...',
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
                    experience: '${doctor.rate} ${"years_of_experience".tr(context)}',
                    imageUrl: doctor.img,
                  ),
                  const SizedBox(height: 24),
                  // Rating Section
                  DoctorRating(rating: doctor.rate?.toString() ?? '0'),
                  const SizedBox(height: 24),
                  // Biography Section
                  BiographySection(biography: biography),
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
