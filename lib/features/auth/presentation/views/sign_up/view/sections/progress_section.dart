import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';

class ProgressSection extends StatelessWidget {
  final int currentStep;
  final void Function(int) onStepTapped;
  final int totalSteps;

  const ProgressSection({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
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
              if (index < totalSteps - 1)
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
