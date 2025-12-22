import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../data/models/centers_appointment_model.dart';
import '../widgets/center_selector.dart';
import '../widgets/section_title.dart';

class CenterSection extends StatelessWidget {
  final List<Centers> centers;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  const CenterSection({
    super.key,
    required this.centers,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: '1. ${"select_a_center".tr(context)}'),
        CenterSelector(
          centers: centers,
          selectedId: selectedId,
          onSelect: onSelect,
        ),
      ],
    );
  }
}
