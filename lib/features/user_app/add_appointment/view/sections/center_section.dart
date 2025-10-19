import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../widgets/center_selector.dart';
import '../widgets/section_title.dart';

class CenterSection extends StatelessWidget {
  final List<Map<String, String>> centers;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const CenterSection({
    super.key,
    required this.centers,
    required this.selectedIndex,
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
          selectedIndex: selectedIndex,
          onSelect: onSelect,
        ),
      ],
    );
  }
}
