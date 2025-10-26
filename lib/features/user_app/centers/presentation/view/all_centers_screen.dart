import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../center_details/view/center_details_screen.dart';
import 'widgets/center_card.dart';

class AllCentersScreen extends StatelessWidget {
  static const String routeName = "/centers";
  final List<Map<String, dynamic>> medicalCenters;

  const AllCentersScreen({super.key, required this.medicalCenters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "all_popular_centers".tr(context)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: medicalCenters.length,
          itemBuilder: (context, index) {
            final center = medicalCenters[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CenterDetailsScreen(center: center),
                  ),
                );
              },
              child: CenterCard(center: center),
            );
          },
        ),
      ),
    );
  }
}
