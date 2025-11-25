import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/features/auth/presentation/views/otp/presentation/view/otp_screen.dart';
import '../../../../../../../core/widgets/custome_text_field.dart';
import '../../../../../../../core/widgets/secondry_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const String routeName = "/reset_password";
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'reset_password'.tr(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "reset_password_message".tr(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                    leading: Icon(
                      Icons.warning,
                      color: AppColors.primaryColors,
                    ),
                  ),
                  SizedBox(height: 32),
                  CustomTextField(
                    hintText: "phone".tr(context),
                    suffixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            SecondryButton(
              text: 'next'.tr(context),
              onPressed: () =>
                  Navigator.pushNamed(context, OTPScreen.routeName),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
