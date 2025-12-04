import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import '../../../../../../../core/utils/colors.dart';
import '../../../../../../../core/widgets/password_textfield.dart';

class ConfirmPasswordScreen extends StatelessWidget {
  static const String routeName = "/confirm_password";
  const ConfirmPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'confirm_password'.tr(context)),
      body: Padding(
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
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 32),
                  PasswordTextField(
                    hintText: "confirm_password".tr(context),
                    controller: TextEditingController(),
                  ),
                ],
              ),
            ),
            PrimaryButton(text: 'save_changes'.tr(context), onPressed: () {}),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
