import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../widgets/settings_tile.dart';
import 'settings_header_section.dart';

class SettingsButtonsSection extends StatelessWidget {
  const SettingsButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SettingsSectionHeader(title: 'account'.tr(context)),
        SettingsTile(
          icon: Icons.language_outlined,
          title: 'change_language'.tr(context),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'change_password'.tr(context),
          onTap: () {},
        ),

        SettingsSectionHeader(title: 'about'.tr(context)),
        SettingsTile(
          icon: Icons.info_outline,
          title: 'about_us'.tr(context),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'terms_conditions'.tr(context),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'privacy_policy'.tr(context),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.contact_support_outlined,
          title: 'contact_us'.tr(context),
          onTap: () {},
        ),

        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'log_out'.tr(context),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
