import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';


class AboutSection extends StatelessWidget {
  final String description;

  const AboutSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          'About the Center',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColors,
          ),
        ),
        const Divider(height: 10, thickness: 1),
        Text(
          description,
          style: const TextStyle(fontSize: 15.0),
        ),
      ],
    );
  }
}
