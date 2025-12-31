import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _saveChangesPressed() {
    if (_formKey.currentState!.validate()) {
      messages(context, "password_updated_successfully", Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'otp'.tr(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "otp_message".tr(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    leading: Icon(
                      Icons.warning,
                      color: AppColors.primaryColors,
                    ),
                  ),
                  SizedBox(height: 32),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: OtpTextField(
                      onSubmit: (otp) {},
                      borderColor: AppColors.primaryColors,
                      focusedBorderColor: AppColors.primaryColors,
                      cursorColor: AppColors.primaryColors,
                      fieldWidth: size.width * 0.15,
                      showFieldAsBox: true,
                      numberOfFields: 4,
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      textStyle: Styles.textStyle18.copyWith(
                        color: AppColors.textButtonColors,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "confirm_password_message".tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          leading: Icon(
                            Icons.warning,
                            color: AppColors.primaryColors,
                          ),
                        ),
                        SizedBox(height: 16),
                        PasswordTextField(
                          hintText: "new_password".tr(context),
                          controller: _newPasswordCtrl,
                          validator: (val) => Validator.validate(
                            val,
                            ValidationState.password,
                            context,
                          ),
                        ),
                        SizedBox(height: 32),
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
                ],
              ),
            ),
            PrimaryButton(
              text: 'save_changes'.tr(context),
              onPressed: _saveChangesPressed,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
