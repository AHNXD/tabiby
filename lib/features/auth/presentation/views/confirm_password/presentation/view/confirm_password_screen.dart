import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/auth/presentation/views/widgets/auth_page_scaffold.dart';
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
    return AuthPageScaffold(
      title: 'confirm_password'.tr(context),
      subtitle: 'confirm_password_message'.tr(context),
      icon: Icons.password_rounded,
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is VerifyResetPasswordSuccess) {
            messages(
              context,
              "password_updated_successfully".tr(context),
              AppColors.greenColor,
            );
            Navigator.pop(context);
          } else if (state is ResetPasswordError) {
            messages(context, state.errorMsg, AppColors.redColor);
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthInfoPanel(
                  text: 'confirm_password_message'.tr(context),
                  icon: Icons.lock_outline_rounded,
                ),
                const SizedBox(height: 22),
                PasswordTextField(
                  hintText: "new_password".tr(context),
                  controller: _newPasswordCtrl,
                  validator: (val) => Validator.validate(
                    val,
                    ValidationState.password,
                    context,
                  ),
                ),
                const SizedBox(height: 18),
                PasswordTextField(
                  hintText: "confirm_password".tr(context),
                  controller: _confirmPasswordCtrl,
                  validator: (val) => Validator.validateConfirmPassword(
                    val,
                    _newPasswordCtrl.text,
                    context,
                  ),
                ),
                const SizedBox(height: 30),
                if (state is ResetPasswordLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColors,
                    ),
                  )
                else
                  PrimaryButton(
                    text: 'save_changes'.tr(context),
                    onPressed: () => _saveChangesPressed(context),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
