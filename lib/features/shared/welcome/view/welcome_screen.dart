import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/auth/presentation/views/login/view/login_screen.dart';
import 'package:tabiby/features/auth/presentation/views/sign_up/view/sign_up_screen.dart';

import 'widgets/tabibi_logo.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = "/welcome";
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 42,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: TabibiLogo(width: 168)),
                        const Spacer(flex: 2),
                        const _DoctorCircleHero(),
                        const Spacer(flex: 1),
                        Text(
                          'welcome_in_our_community'.tr(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.titleColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            height: 1.24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'welcome_message'.tr(context),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.forestMutedTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                        const Spacer(flex: 2),
                        WelcomeActions(
                          onLogin: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          onSignUp: () {
                            Navigator.pushNamed(
                              context,
                              SignUpScreen.routeName,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DoctorCircleHero extends StatelessWidget {
  const _DoctorCircleHero();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double circleSize = (screenWidth * 0.66).clamp(220.0, 292.0);
    final double imageHeight = circleSize * 1.18;

    return SizedBox(
      height: circleSize + 54,
      child: Center(
        child: SizedBox(
          width: circleSize + 20,
          height: circleSize + 54,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColors.withValues(alpha: 0.22),
                        blurRadius: 26,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Image.asset(
                  AssetsData.defaultDoctor,
                  height: imageHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeActionButton extends StatelessWidget {
  const _WelcomeActionButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryColors,
                foregroundColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColors,
                side: const BorderSide(
                  color: AppColors.sageBorderTintColor,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );
  }
}

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({
    super.key,
    required this.onLogin,
    required this.onSignUp,
  });

  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WelcomeActionButton(
          text: 'login'.tr(context),
          onPressed: onLogin,
          isPrimary: true,
        ),
        const SizedBox(height: 12),
        _WelcomeActionButton(
          text: 'sign_up'.tr(context),
          onPressed: onSignUp,
          isPrimary: false,
        ),
      ],
    );
  }
}
