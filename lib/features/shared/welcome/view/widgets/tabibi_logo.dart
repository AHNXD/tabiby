import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';

class TabibiLogo extends StatelessWidget {
  const TabibiLogo({super.key, this.isLight = false, this.width = 190});

  final bool isLight;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isLight ? AssetsData.logoWhite : AssetsData.logoGreen,
      width: width,
      color: isLight ? null : AppColors.primaryColors,
      fit: BoxFit.contain,
    );
  }
}
