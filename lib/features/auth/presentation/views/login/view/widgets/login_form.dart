import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/main_screen.dart';
import 'package:tabiby/features/doctor_app/doctor_dashboard/view/doctor_dashboard_screen.dart';

import '../../../../view-model/login_cubit/login_cubit.dart';
import 'create_account_text.dart';
import 'login_inputs.dart';
import 'terms_checkbox.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool agreeToTerms = true;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onAgreeToggle() {
    setState(() {
      agreeToTerms = !agreeToTerms;
    });
  }

  void onLoginPressed() {
    if (!agreeToTerms) {
      messages(context, 'please_agree_terms'.tr(context), Colors.red);

      return;
    }

    BlocProvider.of<LoginCubit>(
      context,
    ).login(phone: phoneController.text, pass: passwordController.text);
  }

  void _handleSuccess(String role) {
    messages(context, "login_success".tr(context), Colors.green);
    if (role == "patient") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.routeName,
        (route) => false,
      );
    } else if (role == "doctor") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        DoctorDashboardScreen.routeName,
        (route) => false,
      );
    }
  }

  void _handleError(String errorMsg) {
    messages(context, errorMsg, Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          _handleSuccess(state.role);
        } else if (state is LoginError) {
          _handleError(state.errorMsg);
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final bool isLoading = state is LoginLoading;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 32,
                ),
                child: Hero(
                  tag: 'app-logo',
                  child: Image.asset(
                    AssetsData.logoGreen,
                    color: AppColors.primaryColors,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              LoginInputs(
                phoneController: phoneController,
                passwordController: passwordController,
                isLoading: isLoading,
                onLoginPressed: onLoginPressed,
              ),

              const SizedBox(height: 40),

              TermsCheckbox(
                agreeToTerms: agreeToTerms,
                onToggle: onAgreeToggle,
              ),

              const SizedBox(height: 60),
              const CreateAccountText(),
            ],
          );
        },
      ),
    );
  }
}
