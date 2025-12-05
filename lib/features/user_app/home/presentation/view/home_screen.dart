import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/category_screen.dart';
import 'package:tabiby/features/user_app/home/presentation/view/sections/specialties_section.dart';

import '../../data/repo/home_repo.dart';
import '../view-model/home_cubit.dart';
import 'sections/centers_section.dart';
import 'sections/doctor_section.dart';
import 'sections/promo_section.dart';
import 'widgets/build_appbar.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColors,
        onPressed: () {
          Navigator.pushNamed(context, CategoryScreen.routeName);
        },
        child: Icon(Icons.medical_information),
      ),
      appBar: BuildAppbar(name: "Fulan Al-Fulani"),
      body: BlocProvider(
        create: (context) => HomeCubit(getit.get<HomeRepo>())..getHome(),
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  children: [
                    SizedBox(height: 40),
                    PromoSection(),
                    SizedBox(height: 7),
                    SpecialtiesSection(
                      specialties: state.home.specialties ?? [],
                    ),
                    SizedBox(height: 24),
                    DoctorsSection(doctors: state.home.doctors ?? []),
                    SizedBox(height: 16),
                    CentersSection(centers: state.home.centers ?? []),
                    SizedBox(height: 16),
                  ],
                );
              } else if (state is HomeError) {
                return Center(
                  child: CustomErrorWidget(
                    errorMessage: state.errorMsg,
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
