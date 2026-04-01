import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/cache_helper.dart';
import 'package:tabiby/core/utils/colors.dart';
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext dialogContext) {
        Future<void> setLanguage(String value) async {
          await dialogContext.read<LocaleCubit>().changeLanguage(value);
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        }

        return BlocBuilder<LocaleCubit, ChangeLocaleState>(
          builder: (context, localeState) {
            final String currentLanguageCode = localeState.locale.languageCode;

            return SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: AppColors.primaryColors,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'change_language'.tr(context),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2C28),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'language_picker_hint'.tr(context),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _LanguageOptionCard(
                      title: 'language_arabic'.tr(context),
                      subtitle: 'AR',
                      value: 'ar',
                      groupValue: currentLanguageCode,
                      onTap: () => setLanguage('ar'),
                    ),
                    const SizedBox(height: 12),
                    _LanguageOptionCard(
                      title: 'language_english'.tr(context),
                      subtitle: 'EN',
                      value: 'en',
                      groupValue: currentLanguageCode,
                      onTap: () => setLanguage('en'),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text('cancel'.tr(context)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
          return BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              final bool isDeleteLoading = userState is UserLoading;
              final bool anyLoading = isLogoutLoading || isDeleteLoading;
              final bool isPatient =
                  CacheHelper.getData(key: "role") == "patient";
              final String currentLanguageCode = context
                  .watch<LocaleCubit>()
                  .state
                  .locale
                  .languageCode;

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                children: <Widget>[
                  _SettingsHeroCard(
                    languageLabel: _languageLabel(context, currentLanguageCode),
                  ),
                  const SizedBox(height: 22),
                  SettingsSectionHeader(title: 'account'.tr(context)),
                  _SettingsGroupCard(
                    children: <Widget>[
                      SettingsTile(
                        icon: Icons.language_rounded,
                        title: 'change_language'.tr(context),
                        subtitle: 'language_picker_hint'.tr(context),
                        trailingLabel: _languageLabel(
                          context,
                          currentLanguageCode,
                        ),
                        onTap: () => _showLanguageDialog(context),
                      ),
                      if (isPatient) const SizedBox(height: 12),
                      if (isPatient)
                        SettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'change_password'.tr(context),
                          onTap: () => Navigator.pushNamed(
                            context,
                            ConfirmPasswordScreen.routeName,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SettingsSectionHeader(title: 'about'.tr(context)),
                  _SettingsGroupCard(
                    children: <Widget>[
                      SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: 'about_us'.tr(context),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AboutUsScreen.routeName,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.description_outlined,
                        title: 'terms_conditions'.tr(context),
                        onTap: () => Navigator.pushNamed(
                          context,
                          TermsAndConditionsScreen.routeName,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'privacy_policy'.tr(context),
                        onTap: () => Navigator.pushNamed(
                          context,
                          PrivacyPolicyScreen.routeName,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.contact_support_outlined,
                        title: 'contact_us'.tr(context),
                        onTap: () => Navigator.pushNamed(
                          context,
                          ContactUsScreen.routeName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDestructiveButton(
                    context,
                    title: 'log_out'.tr(context),
                    icon: Icons.logout_rounded,
                    isLoading: isLogoutLoading,
                    onTap: anyLoading
                        ? null
                        : () => _showLogoutConfirmation(context),
                  ),

                  const SizedBox(height: 14),
                  if (isPatient)
                    _buildDestructiveButton(
                      context,
                      title: 'delete_account'.tr(context),
                      icon: Icons.delete_forever_rounded,
                      isLoading: isDeleteLoading,
                      isFilled: false,
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

  String _languageLabel(BuildContext context, String languageCode) {
    if (languageCode == 'ar') {
      return 'language_arabic'.tr(context);
    }

    return 'language_english'.tr(context);
  }

  Widget _buildDestructiveButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isLoading,
    bool isFilled = true,
  }) {
    final Color dangerColor = Colors.red.shade400;
    final Color dangerBg = Colors.red.shade50;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: dangerColor.withValues(alpha: 0.08),
        highlightColor: dangerColor.withValues(alpha: 0.04),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: isFilled ? dangerBg : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isFilled
                  ? Colors.transparent
                  : dangerColor.withValues(alpha: 0.22),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isFilled ? Colors.white : dangerBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: dangerColor,
                        ),
                      )
                    : Icon(icon, color: dangerColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  isLoading
                      ? (icon == Icons.logout_rounded
                            ? 'logging_out'.tr(context)
                            : 'deleting_account'.tr(context))
                      : title,
                  style: TextStyle(
                    color: dangerColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!isLoading)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: dangerColor.withValues(alpha: 0.45),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsHeroCard extends StatelessWidget {
  const _SettingsHeroCard({required this.languageLabel});

  final String languageLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -18,
            top: -22,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primaryColors.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -24,
            bottom: -36,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        color: AppColors.primaryColors,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.16,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.language_rounded,
                            color: AppColors.primaryColors,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            languageLabel,
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'settings'.tr(context),
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'settings_intro_subtitle'.tr(context),
                  style: TextStyle(color: Colors.grey.shade700, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  const _LanguageOptionCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColors.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColors.withValues(alpha: 0.35)
                  : Colors.grey.shade200,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(
                    alpha: isSelected ? 0.14 : 0.08,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.primaryColors,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2C28),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColors
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColors
                        : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
