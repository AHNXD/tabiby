import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/category_screen.dart';

import 'sections/appbar_section.dart';
import 'sections/category_section.dart';
import 'sections/centers_section.dart';
import 'sections/doctor_section.dart';
import 'sections/promo_section.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColors,
        onPressed: () {
          Navigator.pushNamed(context, CategoryScreen.routeName);
        },
        child: Icon(Icons.warning),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          children: const [
            SizedBox(height: 10),
            AppBarSection(),
            SizedBox(height: 30),
            PromoSection(),
            SizedBox(height: 7),
            CategorySection(),
            SizedBox(height: 24),
            DoctorsSection(),
            SizedBox(height: 16),
            ClinicsSection(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
