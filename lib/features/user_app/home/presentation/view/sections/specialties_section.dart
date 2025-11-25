import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../specialties/presentation/view/all_specialties_screen.dart';
import '../../../../specialties/presentation/view/widgets/category_item.dart';
import '../widgets/data.dart';
import '../widgets/section_header.dart';

class SpecialtiesSection extends StatelessWidget {
  const SpecialtiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'find_your_doctor'.tr(context),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AllSpecialtiesScreen(specialties: specialties),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        SpecialtyItem(Specialties: specialties),
      ],
    );
  }
}
