import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/features/auth/presentation/view-model/logout_cubit/logout_cubit.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../auth/data/repos/logout_repo/logout_repo.dart';
import 'sections/settings_buttons_section.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "settings".tr(context)),

      body: BlocProvider(
        create: (context) => LogoutCubit(getit<LogoutRepo>()),
        child: SettingsButtonsSection(),
      ),
    );
  }
}
