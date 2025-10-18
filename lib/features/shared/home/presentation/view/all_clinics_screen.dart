import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../user_app/center_details/view/center_details_screen.dart';
import 'widgets/clinic_card.dart';



class AllClinicsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> medicalCenters;

  const AllClinicsScreen({super.key, required this.medicalCenters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "All Popular Clinics"),
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
              child: ClinicCard(center: center),
            );
          },
        ),
      ),
    );
  }
}
