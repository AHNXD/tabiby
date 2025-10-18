import 'package:flutter/material.dart';

import '../widgets/settings_tile.dart';
import 'settings_header_section.dart';

class SettingsButtonsSection extends StatelessWidget {
  const SettingsButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SettingsSectionHeader(title: 'Account'),
        SettingsTile(
          icon: Icons.language_outlined,
          title: 'Change Language',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () {},
        ),

        const SettingsSectionHeader(title: 'About'),
        SettingsTile(icon: Icons.info_outline, title: 'About Us', onTap: () {}),
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Use',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.contact_support_outlined,
          title: 'Contact Us',
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
              title: const Text(
                'Log Out',
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
