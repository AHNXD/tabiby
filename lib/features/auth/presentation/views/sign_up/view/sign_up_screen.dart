import 'package:flutter/material.dart';

import 'sections/appbar_section.dart';
import 'sections/steps_section.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: const [
            AppBarSection(),
            SizedBox(height: 20),
            Expanded(child: StepsSectionWrapper()), 
          ],
        ),
      ),
    );
  }
}
