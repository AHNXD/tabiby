import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import '../../../../../../../core/widgets/custom_login_sign_up_appbar.dart';

class AppBarSection extends StatelessWidget {
  const AppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomLoginSignUpAppBar(title: 'sign_up'.tr(context));
  }
}
