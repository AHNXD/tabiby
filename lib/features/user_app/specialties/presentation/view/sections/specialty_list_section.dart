import 'package:flutter/material.dart';

import '../../../data/models/specialties_model.dart';
import '../widgets/specialty_widget.dart';

class SpecialtyItem extends StatelessWidget {
  final List<SpecializationModel> specialties;
  final VoidCallback? onSeeAll;

  const SpecialtyItem({super.key, required this.specialties, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: specialties.length,
        itemBuilder: (context, index) {
          final specialty = specialties[index];
          return SpecialtyWidget(specialty: specialty);
        },
      ),
    );
  }
}
