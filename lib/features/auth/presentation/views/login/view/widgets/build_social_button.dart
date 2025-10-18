import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../../core/utils/colors.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;

  const SocialButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 246, 245, 245), // رمادي فاتح للخلفية
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          icon,
          color: AppColors.primaryColors, // اللون الأساسي للأيقونة
          size: 24,
        ),
      ),
    );
  }
}
