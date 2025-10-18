import 'package:flutter/material.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import 'widgets/doctor_card.dart';


class AllDoctorsScreen extends StatelessWidget {
  static const String routeName = "/doctors";
  final List<Map<String, dynamic>> doctors;

  const AllDoctorsScreen({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppbar(title: "All Popular Doctors"),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            return DoctorCard(doctor: doctors[index]);
          },
        ),
      ),
    );
  }
}
