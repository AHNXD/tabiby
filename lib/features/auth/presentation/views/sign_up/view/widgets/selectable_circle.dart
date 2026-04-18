import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class SelectableCircle extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;

  const SelectableCircle({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor = AppColors.accentMintColor,
    this.unselectedColor = AppColors.fieldSurfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    final iconColor = isSelected ? AppColors.whiteColor : AppColors.greyColor;

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: color,
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
