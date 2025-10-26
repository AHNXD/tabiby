import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

class CreatedBySection extends StatelessWidget {
  const CreatedBySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'created_by'.tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey,
            height: 1.5,
          ),
        ),
        Text(
          'TechToc',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primaryColors,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
