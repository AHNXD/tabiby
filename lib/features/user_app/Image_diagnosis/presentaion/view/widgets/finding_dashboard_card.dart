import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class FindingDashboardCard extends StatelessWidget {
  const FindingDashboardCard({
    super.key,
    required this.disease,
    required this.probability,
  });

  final String disease;
  final double probability;

  @override
  Widget build(BuildContext context) {
    return XrayFindingCard(disease: disease, probability: probability);
  }
}
