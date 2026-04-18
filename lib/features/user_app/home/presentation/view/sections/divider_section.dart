import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class DividerSection extends StatelessWidget {
  const DividerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1,
      color: AppColors.dividerMutedColor,
      height: 16,
    );
  }
}
