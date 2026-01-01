import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/home/data/models/promot_model.dart';
import 'package:tabiby/features/user_app/home/presentation/view/sections/specialties_section.dart';

import '../../data/repo/home_repo.dart';
import '../view-model/home_cubit.dart';
import 'sections/centers_section.dart';
import 'sections/doctor_section.dart';
import 'sections/promot_section.dart';
import 'widgets/build_appbar.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppbar(),
      body: BlocProvider(
        create: (context) => HomeCubit(getit.get<HomeRepo>())..getHome(),
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                Future<void> onRefresh() async {
                  await context.read<HomeCubit>().getHome();
                }

                return RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    children: [
                      SizedBox(height: 30),
                      PromotSection(
                        promot: state.home.promot?.first ?? Promot(),
                      ),
                      SizedBox(height: 24),
                      SpecialtiesSection(
                        specialties: state.home.specialties ?? [],
                      ),
                      SizedBox(height: 8),
                      DoctorsSection(doctors: state.home.doctors ?? []),
                      SizedBox(height: 8),
                      CentersSection(centers: state.home.centers ?? []),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              } else if (state is HomeError) {
                return Center(
                  child: CustomErrorWidget(
                    textColor: Colors.black,
                    errorMessage: state.errorMsg.tr(context),
                    onRetry: () {
                      context.read<HomeCubit>().getHome();
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
