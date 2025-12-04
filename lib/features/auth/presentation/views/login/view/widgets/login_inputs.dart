import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
// import 'package:tabiby/core/widgets/main_screen.dart'; // No longer needed here
import 'package:tabiby/features/auth/presentation/views/reset_password/presentation/view/reset_password_screen.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../../../../core/widgets/secondry_button.dart';

class LoginInputs extends StatelessWidget {
  const LoginInputs({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.onLoginPressed,
    required this.isLoading,
  });

  final TextEditingController passwordController;
  final TextEditingController phoneController;
  final VoidCallback onLoginPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Opacity(
          opacity: isLoading ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: isLoading,
            child: CustomTextField(
              hintText: "phone".tr(context),
              suffixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              controller: phoneController,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Opacity(
          opacity: isLoading ? 0.6 : 1.0,
          child: IgnorePointer(
            ignoring: isLoading,
            child: PasswordTextField(
              hintText: "password".tr(context),
              controller: passwordController,
            ),
          ),
        ),
        const SizedBox(height: 25),

        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: isLoading
                ? null
                : () => Navigator.pushNamed(
                    context,
                    ResetPasswordScreen.routeName,
                  ),
            child: Text(
              'forget_password'.tr(context),
              style: TextStyle(color: AppColors.textColor, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 40),

        isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColors,
                ),
              )
            : SecondryButton(
                text: "login".tr(context),
                onPressed: onLoginPressed,
              ),
      ],
    );
  }
}
