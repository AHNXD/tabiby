import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/features/auth/presentation/views/widgets/auth_page_scaffold.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/constats.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../core/utils/styles.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/password_textfield.dart';
import '../../../../view-model/reset_password_cubit/reset_password_cubit.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = "/otp";
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  static const int _otpLength = 6;
  String _otpCode = "";
  String? _userEmail;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _userEmail = args;
    }
  }

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _saveChangesPressed(BuildContext context) {
    // 1. Validate Form (Passwords)
    if (_formKey.currentState!.validate()) {
      // 2. Validate OTP presence
      if (_otpCode.length < _otpLength) {
        messages(
          context,
          "please_enter_the_full_OTP_code".tr(context),
          AppColors.redColor,
        );
        return;
      }

      // 3. Call resetPassword Logic
      try {
        final int otpInt = int.parse(_otpCode);
        context.read<ResetPasswordCubit>().resetPassword(
          otp: otpInt,
          password: _newPasswordCtrl.text,
          email: _userEmail!,
        );
      } catch (e) {
        messages(context, "invalid_OTP_format".tr(context), AppColors.redColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      title: 'otp'.tr(context),
      subtitle: 'otp_message'.tr(context),
      icon: Icons.verified_user_outlined,
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is VerifyResetPasswordSuccess) {
            messages(
              context,
              "password_updated_successfully".tr(context),
              AppColors.greenColor,
            );
            // Navigate to Login or Home after success
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is ResetPasswordError) {
            messages(context, state.errorMsg, AppColors.redColor);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthInfoPanel(
                text: 'otp_message'.tr(context),
                icon: Icons.pin_outlined,
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (context, constraints) {
                  const double fieldMargin = 3;
                  const double totalHorizontalMargins =
                      _otpLength * fieldMargin * 2;
                  final double responsiveFieldWidth =
                      ((constraints.maxWidth - totalHorizontalMargins) /
                              _otpLength)
                          .clamp(32.0, 44.0)
                          .toDouble();

                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: OtpTextField(
                      onSubmit: (otp) {
                        _otpCode = otp;
                      },
                      borderColor: AppColors.sageBorderSoftColor,
                      enabledBorderColor: AppColors.sageBorderSoftColor,
                      focusedBorderColor: AppColors.primaryColors,
                      cursorColor: AppColors.primaryColors,
                      fieldWidth: responsiveFieldWidth,
                      fieldHeight: 50,
                      margin: const EdgeInsets.symmetric(
                        horizontal: fieldMargin,
                      ),
                      contentPadding: EdgeInsets.zero,
                      borderWidth: 1.4,
                      showFieldAsBox: true,
                      numberOfFields: _otpLength,
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      textStyle: Styles.textStyle18.copyWith(
                        color: AppColors.textButtonColors,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 26),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthInfoPanel(
                      text: 'confirm_password_message'.tr(context),
                      icon: Icons.password_rounded,
                    ),
                    const SizedBox(height: 18),
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
                  ],
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
          );
        },
      ),
    );
  }
}
