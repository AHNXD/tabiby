import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../../../../core/widgets/secondry_button.dart';

class Step1Widget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onNext;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl;

  const Step1Widget({
    super.key,
    required this.formKey,
    required this.onNext,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
    required this.passwordCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
                  validator: (val) =>
                      Validator.validate(val, ValidationState.normal,context),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'last_name'.tr(context),
                  controller: lastNameCtrl,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.normal,context),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'phone'.tr(context),
                  suffixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  controller: phoneCtrl,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.phoneNumber,context),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  hintText: 'email'.tr(context),
                  suffixIcon: Icons.email,
                  controller: emailCtrl,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.email,context),
                ),

                const SizedBox(height: 30),
                PasswordTextField(
                  hintText: 'password'.tr(context),
                  controller: passwordCtrl,
                  validator: (val) =>
                      Validator.validate(val, ValidationState.password,context),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          SecondryButton(text: 'next'.tr(context), onPressed: onNext),
        ],
      ),
    );
  }
}
