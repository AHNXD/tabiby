import 'package:flutter/material.dart';
import 'sections/appbar_section.dart';
import 'sections/header_section.dart';
import 'sections/about_section.dart';
import 'sections/clinics_section.dart';

class CenterDetailsScreen extends StatelessWidget {
  static const String routeName = "/center_details";
  final Map<String, dynamic> center;

  const CenterDetailsScreen({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSection(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  HeaderSection(
                    name: center['name'] ?? 'Unknown Center',
                    location: center['location'] ?? 'No location',
                    imageUrl: center['image'] ?? '',
                    rating: center['rating'] ?? 0.0,
                  ),
                  AboutSection(
                    description: center['description'] ??
                        'The Advanced Healthcare Center provides comprehensive medical services including consultations, diagnosis, and treatment in various specialties.',
                  ),
                  const ClinicsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
