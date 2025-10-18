import 'package:flutter/material.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import '../../../../../../shared/home/presentation/view/home_screen.dart';

class LoginInputs extends StatelessWidget {
  const LoginInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const CustomTextField(hintText: "Phone"),
        const SizedBox(height: 30),
        const PasswordTextField(hintText: "Password"),
        const SizedBox(height: 25),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Forget Password?',
            style: TextStyle(color: AppColors.textColor, fontSize: 12),
          ),
        ),
        const SizedBox(height: 40),
        SecondryButton(
          text: "Log in",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ],
    );
  }
}
