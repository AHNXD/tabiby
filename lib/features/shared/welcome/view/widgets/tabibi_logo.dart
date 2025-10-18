import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class TabibiLogo extends StatelessWidget {
  const TabibiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/Main Logo First platte.png',
          height: 70,

          color: AppColors.primaryColors,
        ),
        const SizedBox(height: 15),
        Text(
          'Tabiby',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColors,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
