import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/cache_helper.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/features/auth/presentation/views/confirm_password/presentation/view/confirm_password_screen.dart';
import 'package:tabiby/features/auth/presentation/views/login/view/login_screen.dart';
import 'package:tabiby/features/shared/about_us/presentation/view/about_us_screen.dart';
import 'package:tabiby/features/shared/contact_us/presentation/view/contact_us_screen.dart';
import 'package:tabiby/features/shared/welcome/view/welcome_screen.dart';

import '../../../../../core/locale/locale_cubit.dart';
import '../../../../auth/presentation/view-model/logout_cubit/logout_cubit.dart';
import '../../../../user_app/user/presentation/view-model/user_cubit/user_cubit.dart';
import '../../../privacy_policy/presentation/view/privacy_policy_screen.dart';
import '../../../terms_and_condition/presentation/view/terms_and_conditions_screen.dart';
import '../widgets/settings_tile.dart';
import 'settings_header_section.dart';

class SettingsButtonsSection extends StatelessWidget {
  const SettingsButtonsSection({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final currentLanguageCode = context
            .read<LocaleCubit>()
            .state
            .locale
            .languageCode;
        void setLanguage(String value) async {
          await dialogContext.read<LocaleCubit>().changeLanguage(value);
          if (context.mounted) Navigator.of(dialogContext).pop();
        }

        // Updated to match your App's styling (Rounded & Shadowed)
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'change_language'.tr(context),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLanguageOption(
                  context,
                  title: 'العربية',
                  value: 'ar',
                  groupValue: currentLanguageCode,
                  onChanged: setLanguage,
                ),
                _buildLanguageOption(
                  context,
                  title: 'English',
                  value: 'en',
                  groupValue: currentLanguageCode,
                  onChanged: setLanguage,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'cancel'.tr(context),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String value,
    required String groupValue,
    required Function(String) onChanged,
  }) {
    return RadioListTile<String>(
      activeColor: Theme.of(context).primaryColor,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      value: value,
      groupValue: groupValue,
      onChanged: (val) => onChanged(val!),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showAwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: 'log_out'.tr(context),
      desc: 'logout_confirmation_message'.tr(context),
      btnOk: () {
        context.read<LogoutCubit>().logout();
      },
      btnCancel: () {},
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showAwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: 'delete_account'.tr(context),
      desc: 'delete_account_confirmation_message'.tr(context),
      btnOk: () {
        context.read<UserCubit>().deleteProfile();
      },
      btnCancel: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              messages(context, "logout_success".tr(context), Colors.green);
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.routeName,
                (Route<dynamic> route) => false,
              );
            } else if (state is LogoutError) {
              messages(context, state.errorMsg.tr(context), Colors.red);
            }
          },
        ),
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserDeleteSuccess) {
              messages(
                context,
                "account_deleted_success".tr(context),
                Colors.green,
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                WelcomeScreen.routeName,
                (Route<dynamic> route) => false,
              );
            } else if (state is UserError) {
              messages(context, state.errorMsg.tr(context), Colors.red);
            }
          },
        ),
      ],
      child: BlocBuilder<LogoutCubit, LogoutState>(
        builder: (context, logoutState) {
          final bool isLogoutLoading = logoutState is LogoutLoading;
          return BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              final bool isDeleteLoading = userState is UserLoading;
              final bool anyLoading = isLogoutLoading || isDeleteLoading;

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                children: <Widget>[
                  SettingsSectionHeader(title: 'account'.tr(context)),
                  SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'change_language'.tr(context),
                    onTap: () => _showLanguageDialog(context),
                  ),
                  if (CacheHelper.getData(key: "role") == "patient")
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'change_password'.tr(context),
                      onTap: () => Navigator.pushNamed(
                        context,
                        ConfirmPasswordScreen.routeName,
                      ),
                    ),
                  SettingsSectionHeader(title: 'about'.tr(context)),
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'about_us'.tr(context),
                    onTap: () =>
                        Navigator.pushNamed(context, AboutUsScreen.routeName),
                  ),
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'terms_conditions'.tr(context),
                    onTap: () => Navigator.pushNamed(
                      context,
                      TermsAndConditionsScreen.routeName,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'privacy_policy'.tr(context),
                    onTap: () => Navigator.pushNamed(
                      context,
                      PrivacyPolicyScreen.routeName,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.contact_support_outlined,
                    title: 'contact_us'.tr(context),
                    onTap: () =>
                        Navigator.pushNamed(context, ContactUsScreen.routeName),
                  ),
                  const SizedBox(height: 30),

                  // --- NEW BEAUTIFUL BUTTONS ---

                  // 1. Logout Button
                  _buildDestructiveButton(
                    context,
                    title: 'log_out'.tr(context),
                    icon: Icons.logout_rounded,
                    isLoading: isLogoutLoading,
                    onTap: anyLoading
                        ? null
                        : () => _showLogoutConfirmation(context),
                  ),

                  const SizedBox(height: 16),

                  // 2. Delete Account Button
                  if (CacheHelper.getData(key: "role") == "patient")
                    _buildDestructiveButton(
                      context,
                      title: 'delete_account'.tr(context),
                      icon: Icons.delete_forever_rounded,
                      isLoading: isDeleteLoading,
                      isFilled:
                          false, // Outline style for secondary destructive action
                      onTap: anyLoading
                          ? null
                          : () => _showDeleteAccountConfirmation(context),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDestructiveButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isLoading,
    bool isFilled = true,
  }) {
    // Red Color Palette
    final Color dangerColor = Colors.red.shade400;
    final Color dangerBg = Colors.red.shade50;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        color: isFilled ? dangerBg : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isFilled
              ? BorderSide.none
              : BorderSide(color: dangerColor.withOpacity(0.3), width: 1.5),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: dangerColor.withOpacity(0.1),
          highlightColor: dangerColor.withOpacity(0.05),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Icon Bubble
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isFilled ? Colors.white : dangerBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: dangerColor,
                          ),
                        )
                      : Icon(icon, color: dangerColor, size: 20),
                ),
                const SizedBox(width: 16),

                // Text
                Text(
                  isLoading
                      ? (icon == Icons.logout_rounded
                            ? 'logging_out'.tr(context)
                            : 'deleting_account'.tr(context))
                      : title,
                  style: TextStyle(
                    color: dangerColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const Spacer(),

                // Trailing Arrow
                if (!isLoading)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: dangerColor.withOpacity(0.5),
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
