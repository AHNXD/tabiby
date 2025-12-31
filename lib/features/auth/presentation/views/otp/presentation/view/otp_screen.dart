import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';

import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/constats.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../core/utils/styles.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
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
          Colors.red,
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
        messages(context, "invalid_OTP_format".tr(context), Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double responsiveFieldWidth = (size.width - 150) / _otpLength;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'otp'.tr(context)),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is VerifyResetPasswordSuccess) {
            messages(
              context,
              "password_updated_successfully".tr(context),
              Colors.green,
            );
            // Navigate to Login or Home after success
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is ResetPasswordError) {
            messages(context, state.errorMsg, Colors.red);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text(
                          "otp_message".tr(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(),
                        ),
                        leading: const Icon(
                          Icons.warning,
                          color: AppColors.primaryColors,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: OtpTextField(
                          onSubmit: (otp) {
                            _otpCode = otp;
                          },

                          borderColor: AppColors.primaryColors,
                          focusedBorderColor: AppColors.primaryColors,
                          cursorColor: AppColors.primaryColors,
                          fieldWidth: responsiveFieldWidth,
                          showFieldAsBox: true,
                          numberOfFields: 6,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                          textStyle: Styles.textStyle18.copyWith(
                            color: AppColors.textButtonColors,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        key: _formKey,
                        child: Column(
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
                            const SizedBox(height: 16),
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
                              validator: (val) =>
                                  Validator.validateConfirmPassword(
                                    val,
                                    _newPasswordCtrl.text,
                                    context,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
          );
        },
      ),
    );
  }
}
