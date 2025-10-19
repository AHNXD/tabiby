import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
    title: Text('${"hello".tr(context)}, ${"dr".tr(context)} Smith!'),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {},
      ),
      const Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/doctor4.png'),
        ),
      ),
    ],
  );
}
