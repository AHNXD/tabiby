import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';

class TabibiLogo extends StatelessWidget {
  const TabibiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Hero(
        tag: 'app-logo',
        child: Image.asset(
          AssetsData.logoGreen,
          color: AppColors.primaryColors,
        ),
      ),
    );
  }
}
