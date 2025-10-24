import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../center_details/view/center_details_screen.dart';
import '../../../../clinics/presentation/view/all_clinics_screen.dart';
import '../../../../clinics/presentation/view/widgets/clinic_card.dart';
import '../widgets/data.dart';
import '../widgets/section_header.dart';

class ClinicsSection extends StatelessWidget {
  const ClinicsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'popular_centers'.tr(context),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AllClinicsScreen(medicalCenters: medicalCenters),
              ),
            );
          },
        ),
        SizedBox(
          height: 165,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: medicalCenters.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CenterDetailsScreen(center: medicalCenters[index]),
                    ),
                  );
                },
                child: ClinicCard(center: medicalCenters[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
