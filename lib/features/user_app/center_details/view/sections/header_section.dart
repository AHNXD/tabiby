import 'package:flutter/material.dart';
import '../widgets/clinic_header.dart';

class HeaderSection extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final double rating;

  const HeaderSection({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return ClinicHeader(
      name: name,
      location: location,
      imageUrl: imageUrl,
      rating: rating,
    );
  }
}
