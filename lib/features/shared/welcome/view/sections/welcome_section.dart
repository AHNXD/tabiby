import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

class WelcomSection extends StatelessWidget {
  const WelcomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'welcome_in_our_community'.tr(context),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.black87Color,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'welcome_message'.tr(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.greyColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
