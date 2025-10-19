import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../../../../core/widgets/secondry_button.dart';

class Step1Widget extends StatelessWidget {
  final VoidCallback onNext;

  const Step1Widget({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          CustomTextField(hintText: 'first_name'.tr(context)),
          const SizedBox(height: 30),
          CustomTextField(hintText: 'last_name'.tr(context)),
          const SizedBox(height: 30),
          CustomTextField(
            hintText: 'phone'.tr(context),
            suffixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: 30),
          PasswordTextField(hintText: 'password'.tr(context)),
          const SizedBox(height: 40),
          SecondryButton(text: 'next'.tr(context), onPressed: onNext),
        ],
      ),
    );
  }
}
