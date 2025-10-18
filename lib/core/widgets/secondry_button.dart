import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SecondryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SecondryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColors,
            side: const BorderSide(color: AppColors.primaryColors, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(text, style: const TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}
