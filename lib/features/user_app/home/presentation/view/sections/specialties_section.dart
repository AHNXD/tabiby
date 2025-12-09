import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/specialties/data/models/specialties_model.dart';

import '../../../../specialties/presentation/view/all_specialties_screen.dart';
import '../../../../specialties/presentation/view/sections/specialty_list_section.dart';

import '../widgets/section_header.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key, required this.specialties});
  final List<SpecializationModel> specialties;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'find_your_doctor'.tr(context),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllSpecialtiesScreen()),
            );
          },
        ),
        const SizedBox(height: 8),
        SpecialtyItem(specialties: specialties),
      ],
    );
  }
}
