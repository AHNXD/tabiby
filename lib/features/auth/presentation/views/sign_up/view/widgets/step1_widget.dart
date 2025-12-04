import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../../../../core/widgets/secondry_button.dart';

class Step1Widget extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;

  const Step1Widget({
    super.key,
    required this.onNext,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                hintText: 'first_name'.tr(context),
                controller: firstNameCtrl,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hintText: 'last_name'.tr(context),
                controller: lastNameCtrl,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hintText: 'phone'.tr(context),
                suffixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                controller: phoneCtrl,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hintText: 'email'.tr(context),
                suffixIcon: Icons.email,
                controller: emailCtrl,
              ),

              const SizedBox(height: 30),
              PasswordTextField(
                hintText: 'password'.tr(context),
                controller: passwordCtrl,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        SecondryButton(text: 'next'.tr(context), onPressed: onNext),
      ],
    );
  }
}
