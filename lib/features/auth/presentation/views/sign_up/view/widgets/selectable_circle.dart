import 'package:flutter/material.dart';

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
    this.selectedColor = const Color(0xFF74B89C), 
    this.unselectedColor = const Color(0xFFF6F6F6),
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    final iconColor = isSelected ? Colors.white : Colors.grey;

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
