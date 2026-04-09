import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/chest_xray_result_screen.dart';

class DiagnosisResultScreen extends StatelessWidget {
  const DiagnosisResultScreen({super.key, this.viewModel});

  final Object? viewModel;

  @override
  Widget build(BuildContext context) {
    return const ChestXrayResultScreen();
  }
}
