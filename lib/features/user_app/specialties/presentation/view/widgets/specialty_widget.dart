import 'package:flutter/material.dart';

import '../../../../doctors/presentation/view/all_doctors_screen.dart';
import '../../../data/models/specialties_model.dart';

class SpecialtyWidget extends StatelessWidget {
  const SpecialtyWidget({super.key, required this.specialty});

  final SpecializationModel specialty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AllDoctorsScreen.routeName,
        arguments: {'specialtyID': specialty.id},
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            margin: EdgeInsets.all(8),

            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                specialty.img ?? 'assets/icons/appIcon.png',
                width: 32,
                height: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              specialty.name ?? '',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
