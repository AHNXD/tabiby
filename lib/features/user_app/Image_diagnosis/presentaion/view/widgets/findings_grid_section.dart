import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class FindingsGridSection extends StatelessWidget {
  const FindingsGridSection({super.key, required this.results});

  final List<MapEntry<String, double>> results;

  @override
  Widget build(BuildContext context) {
    return XrayFindingsGridSection(results: results);
  }
}
