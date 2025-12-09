import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/center_details/data/models/centers_model.dart';
import 'sections/appbar_section.dart';
import 'sections/header_section.dart';
import 'sections/about_section.dart';
import 'sections/clinics_section.dart';

class CenterDetailsScreen extends StatelessWidget {
  static const String routeName = "/center_details";
  final Centers center;

  const CenterDetailsScreen({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSection(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                HeaderSection(
                  name: center.name!,
                  location: center.location ?? "",
                  imageUrl: 'assets/images/center.webp',
                ),
                AboutSection(
                  description: 'default_center_description'.tr(context),
                ),
                const ClinicsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
