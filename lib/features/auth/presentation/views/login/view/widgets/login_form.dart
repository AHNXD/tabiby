import 'package:flutter/material.dart';
import 'create_account_text.dart';
import 'login_inputs.dart';
import 'social_login_row.dart';
import 'terms_checkbox.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool agreeToTerms = true;

  void onAgreeToggle() {
    setState(() {
      agreeToTerms = !agreeToTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        LoginInputs(),          
        const SizedBox(height: 40),
        TermsCheckbox(            
          agreeToTerms: agreeToTerms,
          onToggle: onAgreeToggle,
        ),
        const SizedBox(height: 40),
        SocialLoginRow(),         
        const SizedBox(height: 60),
        const CreateAccountText() 
      ],
    );
  }
}
