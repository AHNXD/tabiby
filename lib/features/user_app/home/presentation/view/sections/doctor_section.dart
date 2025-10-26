import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../doctors/presentation/view/all_doctors_screen.dart';
import '../widgets/data.dart';
import '../../../../doctors/presentation/view/widgets/doctor_card.dart';
import '../widgets/section_header.dart';

class DoctorsSection extends StatelessWidget {
  const DoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'popular_doctors'.tr(context),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllDoctorsScreen(doctors: doctors),
              ),
            );
          },
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,

              itemCount: doctors.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 150,
                  child: DoctorCard(doctor: doctors[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
