import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class NumberOfChildrenField extends StatelessWidget {
  final bool enabled;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const NumberOfChildrenField({
    super.key,
    required this.enabled,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.fieldSurfaceColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: const Icon(
                  Icons.chevron_left,
                  color: AppColors.greyColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warmGreyTextColor,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onIncrement,
                child: const Icon(
                  Icons.chevron_right,
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
