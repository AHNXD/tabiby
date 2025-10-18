import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';

class ProgressSection extends StatelessWidget {
  final int currentStep;
  final void Function(int) onStepTapped;

  const ProgressSection({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentStep;
        return GestureDetector(
          onTap: () => onStepTapped(index),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: isActive
                    ? AppColors.primaryColors
                    : Colors.grey[300],
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (index < 2)
                Container(
                  width: 40,
                  height: 2,
                  color: index < currentStep
                      ? AppColors.primaryColors
                      : Colors.grey[300],
                ),
            ],
          ),
        );
      }),
    );
  }
}
