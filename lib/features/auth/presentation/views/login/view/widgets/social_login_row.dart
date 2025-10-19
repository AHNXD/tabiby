import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/utils/colors.dart';
import 'build_social_button.dart';


class SocialLoginRow extends StatelessWidget {
  const SocialLoginRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children:  [
            Expanded(child: Divider(color: AppColors.textColor)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'or'.tr(context),
                style: TextStyle(color: AppColors.textColor, fontSize: 20),
              ),
            ),
            Expanded(child: Divider(color: AppColors.textColor)),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SocialButton(icon: FontAwesomeIcons.google),
          ],
        ),
      ],
    );
  }
}
