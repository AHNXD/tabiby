import 'package:flutter/material.dart';

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
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: const Icon(Icons.chevron_left, color: Colors.grey),
              ),
              const SizedBox(width: 10),
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onIncrement,
                child: const Icon(Icons.chevron_right, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
