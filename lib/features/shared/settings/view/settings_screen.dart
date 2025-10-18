import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';
import 'sections/settings_buttons_section.dart';


class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Settings"),

      body: SettingsButtonsSection(),
    );
  }
}




