import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: Text(
      '${"hello".tr(context)}, ${"dr".tr(context)} Smith!',
      style: TextStyle(color: AppColors.textButtonColors),
    ),
    actions: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/doctor4.png'),
        ),
      ),
    ],
  );
}
