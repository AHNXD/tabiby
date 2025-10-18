import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';
import 'sections/affiliated_centers_section.dart';
import 'sections/biography_section.dart';
import 'widgets/booking_button.dart';
import 'widgets/doctor_header.dart';
import 'widgets/doctor_rating.dart';

class DoctorDetailsScreen extends StatelessWidget {
  static const String routeName = "/doctor_details";
  final String doctorName;
  final String specialty;
  final String experience;
  final String imageUrl;
  final String rating;
  final String biography;
  final List<Map<String, dynamic>> centers;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.experience,
    required this.imageUrl,
    required this.rating,
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
      appBar: const CustomAppbar(title: "Doctor Details"),
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
                    name: doctorName,
                    specialty: specialty,
                    experience: experience,
                    imageUrl: imageUrl,
                  ),
                  const SizedBox(height: 24),
                  // Rating Section
                  DoctorRating(rating: rating),
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
