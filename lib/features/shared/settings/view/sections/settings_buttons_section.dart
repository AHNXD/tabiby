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

          // ignore: use_build_context_synchronously
          Navigator.of(dialogContext).pop();
        }

        return AlertDialog(
          title: Text('change_language'.tr(context)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('العربية'),
                leading: Radio<String>(
                  value: 'ar',
                  groupValue: currentLanguageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      setLanguage(value);
                    }
                  },
                ),
                onTap: () => setLanguage('ar'),
              ),

              ListTile(
                title: const Text('English'),
                leading: Radio<String>(
                  value: 'en',
                  groupValue: currentLanguageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      setLanguage(value);
                    }
                  },
                ),
                onTap: () => setLanguage('en'),
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
          // 🔴 Use BlocBuilder for UserCubit to handle delete loading state
          return BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              final bool isDeleteLoading = userState is UserLoading;
              final bool anyLoading = isLogoutLoading || isDeleteLoading;

              return ListView(
                children: <Widget>[
                  SettingsSectionHeader(title: 'account'.tr(context)),
                  SettingsTile(
                    icon: Icons.language_outlined,
                    title: 'change_language'.tr(context),
                    onTap: () => _showLanguageDialog(context),
                  ),
                  if(CacheHelper.getData(key: "role") == "patient")
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

                  const SizedBox(height: 20),

                  // 🔴 LOGOUT BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: isLogoutLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : const Icon(Icons.logout, color: Colors.red),
                        title: Text(
                          isLogoutLoading
                              ? 'logging_out'.tr(context)
                              : 'log_out'.tr(context),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: anyLoading
                            ? null
                            : () => _showLogoutConfirmation(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
if(CacheHelper.getData(key: "role") == "patient")
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: isDeleteLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                              )
                            : const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                        title: Text(
                          isDeleteLoading
                              ? 'deleting_account'.tr(context)
                              : 'delete_account'.tr(context),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: anyLoading
                            ? null
                            : () => _showDeleteAccountConfirmation(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
