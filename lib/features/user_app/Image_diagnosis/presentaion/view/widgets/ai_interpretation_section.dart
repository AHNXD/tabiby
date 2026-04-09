import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class AiInterpretationSection extends StatelessWidget {
  const AiInterpretationSection({super.key, required this.aiAnalysisText});

  final String? aiAnalysisText;

  @override
  Widget build(BuildContext context) {
    if (aiAnalysisText == null) {
      return const SizedBox.shrink();
    }

    return XrayNarrativeSection(aiAnalysisText: aiAnalysisText!);
  }
}
