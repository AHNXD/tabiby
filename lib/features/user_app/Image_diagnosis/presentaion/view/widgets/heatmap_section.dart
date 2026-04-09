import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class HeatmapSection extends StatelessWidget {
  const HeatmapSection({super.key, this.heatmapUrl});

  final String? heatmapUrl;

  @override
  Widget build(BuildContext context) {
    return XrayHeatmapSection(heatmapUrl: heatmapUrl);
  }
}
