import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/functions.dart';
import '../../../../../../../core/utils/validation.dart';
import '../../../../../../../core/widgets/password_textfield.dart';

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

  void _saveChangesPressed() {
    if (_formKey.currentState!.validate()) {
      messages(context, "password_updated_successfully", Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'confirm_password'.tr(context)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
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
                    SizedBox(height: 32),
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
              PrimaryButton(
                text: 'save_changes'.tr(context),
                onPressed: _saveChangesPressed,
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
