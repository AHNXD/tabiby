import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../view-model/reset_password_cubit/reset_password_cubit.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  static const String routeName = "/confirm_password";
  const ConfirmPasswordScreen({super.key});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _saveChangesPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ResetPasswordCubit>().resetPasswordInApp(
        password: _newPasswordCtrl.text,
        confirmPassword: _confirmPasswordCtrl.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'confirm_password'.tr(context)),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is VerifyResetPasswordSuccess) {
            messages(
              context,
              "password_updated_successfully".tr(context),
              Colors.green,
            );
            Navigator.pop(context);
          } else if (state is ResetPasswordError) {
            messages(context, state.errorMsg, Colors.red);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            "confirm_password_message".tr(context),
                            textAlign: TextAlign.center,
                            style: const TextStyle(),
                          ),
                          leading: const Icon(
                            Icons.warning,
                            color: AppColors.primaryColors,
                          ),
                        ),
                        const SizedBox(height: 32),
                        PasswordTextField(
                          hintText: "new_password".tr(context),
                          controller: _newPasswordCtrl,
                          validator: (val) => Validator.validate(
                            val,
                            ValidationState.password,
                            context,
                          ),
                        ),
                        const SizedBox(height: 32),
                        PasswordTextField(
                          hintText: "confirm_password".tr(context),
                          controller: _confirmPasswordCtrl,
                          validator: (val) => Validator.validateConfirmPassword(
                            val,
                            _newPasswordCtrl.text,
                            context,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Show Loading or Button
                  if (state is ResetPasswordLoading)
                    const CircularProgressIndicator()
                  else
                    PrimaryButton(
                      text: 'save_changes'.tr(context),
                      onPressed: () => _saveChangesPressed(context),
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
