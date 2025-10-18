import 'package:flutter/material.dart';

import 'sections/buttons_section.dart';
import 'sections/created_by_section.dart';
import 'sections/welcome_section.dart';
import 'widgets/tabibi_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 30),
                TabibiLogo(),
                SizedBox(height: 20),
                const SizedBox(height: 60),
                WelcomSection(),
                const SizedBox(height: 50),
                ButtonsSection(),
                const SizedBox(height: 10),
                CreatedBySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





