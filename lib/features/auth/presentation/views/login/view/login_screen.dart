import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/auth/presentation/view-model/login_cubit/login_cubit.dart';
import 'package:tabiby/features/auth/presentation/views/widgets/auth_page_scaffold.dart';

import '../../../../../../core/utils/services_locater.dart';
import '../../../../data/repos/login_repo/login_repo.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login";
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getit.get<LoginRepo>()),
      child: AuthPageScaffold(
        title: 'login'.tr(context),
        subtitle: 'welcome_message'.tr(context),
        icon: Icons.login_rounded,
        showBackButton: false,
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return const LoginForm();
          },
        ),
      ),
    );
  }
}
