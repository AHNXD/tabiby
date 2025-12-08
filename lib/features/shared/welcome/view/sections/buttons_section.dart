import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secondry_button.dart';
import '../../../../auth/presentation/views/login/view/login_screen.dart';
import '../../../../auth/presentation/views/sign_up/view/sign_up_screen.dart';

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: "login".tr(context),
          onPressed: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        ),

        const SizedBox(height: 20),
        SecondryButton(
          text: "sign_up".tr(context),
          onPressed: () {
            Navigator.pushNamed(context, SignUpScreen.routeName);
          },
        ),
      ],
    );
  }
}
