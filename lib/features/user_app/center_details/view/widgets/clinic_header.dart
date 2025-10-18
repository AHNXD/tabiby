import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class ClinicHeader extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final double rating;

  const ClinicHeader({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            imageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
