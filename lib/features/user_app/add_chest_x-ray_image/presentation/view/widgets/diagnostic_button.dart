import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/widgets/xray_sections.dart';

class DiagnosticButton extends StatelessWidget {
  const DiagnosticButton({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return XrayAnalyzeButton(
      isLoading: isLoading,
      isEnabled: isEnabled,
      onPressed: onPressed,
    );
  }
}
