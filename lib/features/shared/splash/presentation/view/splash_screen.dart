import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/cache_helper.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/main_screen.dart';
import 'package:tabiby/features/doctor_app/doctor_appointment/presentation/view/doctor_appointment_screen.dart';
import 'package:tabiby/features/shared/welcome/view/welcome_screen.dart';
import 'package:tabiby/features/user_app/user/presentation/view-model/user_cubit/user_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(seconds: 1), _splashLogic);
      }
    });

    _controller.forward();
  }

  bool _checkToken() {
    String token = CacheHelper.getData(key: 'token') ?? '';
    return token.isNotEmpty;
  }

  String _getRole() {
    String role = CacheHelper.getData(key: 'role') ?? '';
    return role;
  }

  void _splashLogic() {
    bool trueToken = _checkToken();
    if (trueToken) {
      String role = _getRole();

      if (role == "patient") {
        context.read<UserCubit>().getProfile();
        Navigator.pushReplacementNamed(context, MainScreen.routeName);
      } else if (role == "doctor") {
        context.read<UserCubit>().getProfile();
        Navigator.pushReplacementNamed(
          context,
          DoctorAppointmentScreen.routeName,
        );
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      }
    } else {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColors,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Hero(
                tag: 'app-logo',
                child: Image.asset(AssetsData.logoWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
