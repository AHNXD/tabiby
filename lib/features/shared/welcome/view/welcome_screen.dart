import 'package:flutter/material.dart';

import 'sections/buttons_section.dart';
import 'sections/welcome_section.dart';
import 'widgets/tabibi_logo.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = "/welcome";
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabibiLogo(),
                SizedBox(height: 16),
                const SizedBox(height: 16),
                WelcomSection(),
                const SizedBox(height: 16),
                ButtonsSection(),
                // const SizedBox(height: 10),
                // CreatedBySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
