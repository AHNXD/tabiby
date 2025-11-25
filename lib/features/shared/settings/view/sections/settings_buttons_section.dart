import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/auth/presentation/views/confirm_password/presentation/view/confirm_password_screen.dart';

import '../../../../../core/locale/locale_cubit.dart';
import '../widgets/settings_tile.dart';
import 'settings_header_section.dart';

class SettingsButtonsSection extends StatelessWidget {
  const SettingsButtonsSection({super.key});
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Get the current language code from the cubit state
        final currentLanguageCode = context
            .read<LocaleCubit>()
            .state
            .locale
            .languageCode;

        return AlertDialog(
          title: Text('change_language'.tr(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Option 1: Arabic (ar)
              ListTile(
                title: const Text('العربية'),
                leading: Radio<String>(
                  value: 'ar',
                  groupValue: currentLanguageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      // Dispatch the event and close the dialog
                      context.read<LocaleCubit>().changeLanguage(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                onTap: () {
                  // Dispatch the event and close the dialog
                  context.read<LocaleCubit>().changeLanguage('ar');
                  Navigator.of(context).pop();
                },
              ),
              // Option 2: English (en)
              ListTile(
                title: const Text('English'),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: currentLanguageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      // Dispatch the event and close the dialog
                      context.read<LocaleCubit>().changeLanguage(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                onTap: () {
                  // Dispatch the event and close the dialog
                  context.read<LocaleCubit>().changeLanguage('en');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SettingsSectionHeader(title: 'account'.tr(context)),
        SettingsTile(
          icon: Icons.language_outlined,
          title: 'change_language'.tr(context),
          onTap: () => _showLanguageDialog(context),
        ),
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'change_password'.tr(context),
          onTap: () =>
              Navigator.pushNamed(context, ConfirmPasswordScreen.routeName),
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
