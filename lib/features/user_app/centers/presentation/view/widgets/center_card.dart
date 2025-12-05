import 'package:flutter/material.dart';
import 'package:tabiby/features/user_app/centers/data/models/centers_model.dart';

class CenterCard extends StatelessWidget {
  final CentersModel center;
  const CenterCard({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/center.webp",
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            center.name ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            center.address ?? '',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
