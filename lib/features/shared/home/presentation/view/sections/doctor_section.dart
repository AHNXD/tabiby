import 'package:flutter/material.dart';

import '../all_doctors_screen.dart';
import '../widgets/data.dart';
import '../widgets/doctor_card.dart';
import '../widgets/section_header.dart';



class DoctorsSection extends StatelessWidget {
  const DoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Popular Doctors:',
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllDoctorsScreen(doctors: doctors),
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
              itemCount: doctors.length,
              itemBuilder: (context, index) => DoctorCard(doctor: doctors[index]),
            ),
          ),
        ),
      ],
    );
  }
}
