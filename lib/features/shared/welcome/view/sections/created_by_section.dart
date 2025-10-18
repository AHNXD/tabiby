import 'package:flutter/material.dart';

class CreatedBySection extends StatelessWidget {
  const CreatedBySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Created By',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.grey,
        height: 1.5,
      ),
    );
  }
}