import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/primary_button.dart';

class NewAnalysisButton extends StatelessWidget {
  const NewAnalysisButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: onPressed,
      text: 'xray_start_new_analysis'.tr(context),
      fontSize: 18,
    );
  }
}
