import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final RegExpMatch? match = RegExp(r'^(\d+)\.\s*(.*)$').firstMatch(title);
    final String? stepNumber = match?.group(1);
    final String displayTitle = match?.group(2) ?? title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          if (stepNumber != null) ...<Widget>[
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[
                    AppColors.primaryColors,
                    AppColors.forestAccentColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primaryColors.withValues(alpha: 0.28),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                stepNumber,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              displayTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.forestDeepColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
