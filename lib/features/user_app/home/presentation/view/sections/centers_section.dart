import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../center_details/view/center_details_screen.dart';
import '../../../../centers/presentation/view/all_centers_screen.dart';
import '../../../../centers/presentation/view/widgets/center_card.dart';
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
                    AllCentersScreen(medicalCenters: medicalCenters),
              ),
            );
          },
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 170,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: CenterCard(center: medicalCenters[index]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
