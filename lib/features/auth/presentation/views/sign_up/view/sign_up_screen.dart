import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/auth/data/repos/register_repo/register_repo.dart';
import 'package:tabiby/features/auth/presentation/view-model/register_cubit/register_cubit.dart';
import 'package:tabiby/features/auth/presentation/views/widgets/auth_page_scaffold.dart';

import '../../../../../../core/utils/services_locater.dart';
import 'sections/steps_section.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = "/sign_up";
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(getit.get<RegisterRepo>()),
      child: AuthPageScaffold(
        title: 'sign_up'.tr(context),
        subtitle: 'welcome_message'.tr(context),
        icon: Icons.person_add_alt_rounded,
        scrollable: false,
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return const StepsSectionWrapper();
          },
        ),
      ),
    );
  }
}
