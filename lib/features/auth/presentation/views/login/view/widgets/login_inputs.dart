import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/main_screen.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../../../../core/widgets/secondry_button.dart';

class LoginInputs extends StatelessWidget {
  const LoginInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(hintText: "phone".tr(context)),
        const SizedBox(height: 30),
        PasswordTextField(hintText: "password".tr(context)),
        const SizedBox(height: 25),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'forget_password'.tr(context),
            style: TextStyle(color: AppColors.textColor, fontSize: 12),
          ),
        ),
        const SizedBox(height: 40),
        SecondryButton(
          text: "login".tr(context),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),
      ],
    );
  }
}
