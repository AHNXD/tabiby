import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class TermsCheckbox extends StatelessWidget {
  final bool agreeToTerms;
  final VoidCallback onToggle;

  const TermsCheckbox({
    super.key,
    required this.agreeToTerms,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: agreeToTerms
                  ? AppColors.primaryColors
                  : Colors.transparent,
              border: Border.all(
                color: agreeToTerms
                    ? AppColors.primaryColors
                    : AppColors.textColor,
                width: 1.5,
              ),
            ),
            child: agreeToTerms
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: AppColors.textColor),
              children: [
                const TextSpan(text: 'I have read and agree to the app '),
                TextSpan(
                  text: 'terms conditions',
                  style: const TextStyle(
                    color: AppColors.primaryColors,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'privacy policy.',
                  style: const TextStyle(
                    color: AppColors.primaryColors,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
