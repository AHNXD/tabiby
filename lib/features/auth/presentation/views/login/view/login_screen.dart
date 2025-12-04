import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/features/auth/presentation/view-model/login_cubit/login_cubit.dart';

import '../../../../../../core/utils/services_locater.dart';
import '../../../../data/repos/login_repo/login_repo.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'login'.tr(context), showBackButton: false),
      body: BlocProvider(
        create: (context) => LoginCubit(getit.get<LoginRepo>()),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return LoginForm();
              },
            ),
          ),
        ),
      ),
    );
  }
}
