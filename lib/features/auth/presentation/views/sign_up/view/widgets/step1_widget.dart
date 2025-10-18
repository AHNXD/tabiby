import 'package:flutter/material.dart';

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
          const CustomTextField(hintText: 'Name'),
          const SizedBox(height: 30),
          const CustomTextField(hintText: 'Last Name'),
          const SizedBox(height: 30),
          const CustomTextField(hintText: 'Number', suffixIcon: Icons.phone_outlined),
          const SizedBox(height: 30),
          const PasswordTextField(hintText: 'Password'),
          const SizedBox(height: 40),
          SecondryButton(text: 'Next', onPressed: onNext),
        ],
      ),
    );
  }
}
