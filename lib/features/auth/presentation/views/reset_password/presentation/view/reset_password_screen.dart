import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/features/auth/presentation/views/otp/presentation/view/otp_screen.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';
import '../../../../view-model/reset_password_cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = "/reset_password";
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'reset_password'.tr(context)),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            Navigator.pushNamed(context, OTPScreen.routeName,arguments: _emailController.text.trim());
          } else if (state is ResetPasswordError) {
            messages(context, state.errorMsg, Colors.red);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            "reset_password_message".tr(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(),
                          ),
                          leading: const Icon(
                            Icons.warning,
                            color: AppColors.primaryColors,
                          ),
                        ),
                        const SizedBox(height: 32),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "email".tr(context),
                          suffixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => Validator.validate(
                            val,
                            ValidationState.email,
                            context,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (state is ResetPasswordLoading)
                    const CircularProgressIndicator()
                  else
                    SecondryButton(
                      text: 'next'.tr(context),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ResetPasswordCubit>().forgetPassword(
                            email: _emailController.text.trim(),
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
