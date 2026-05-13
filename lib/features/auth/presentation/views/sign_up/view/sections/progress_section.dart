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
    final List<Widget> stepWidgets = [];
    for (int index = 0; index < totalSteps; index++) {
      final bool isActive = index == currentStep;
      final bool isCompleted = index < currentStep;
      final Color stepColor = isActive || isCompleted
          ? AppColors.primaryColors
          : AppColors.grey300Color;

      stepWidgets.add(
        GestureDetector(
          onTap: () => onStepTapped(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: stepColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.whiteColor,
                      size: 18,
                    )
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ),
      );

      if (index < totalSteps - 1) {
        stepWidgets.add(
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primaryColors
                    : AppColors.grey300Color,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.sageTintSurfaceAltColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.sageBorderSoftColor),
      ),
      child: Row(children: stepWidgets),
    );
  }
}
