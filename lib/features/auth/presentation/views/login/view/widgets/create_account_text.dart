import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../sign_up/view/sign_up_screen.dart';

class CreateAccountText extends StatelessWidget {
  const CreateAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: AppColors.textColor),
          children: [
             TextSpan(text: "dont_have_an_account".tr(context)),
            TextSpan(
              text: 'create_one'.tr(context),
              style: const TextStyle(
                color: AppColors.primaryColors,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
