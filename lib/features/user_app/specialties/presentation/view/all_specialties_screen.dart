import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/specialties/data/repos/user_repo.dart';
import 'package:tabiby/features/user_app/specialties/presentation/view-model/specialties_cubit.dart';

import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import 'widgets/specialty_widget.dart';

class AllSpecialtiesScreen extends StatelessWidget {
  static const String routeName = "/specialties";

  const AllSpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: CustomAppbar(title: "all_specialties".tr(context)),
      ),
      body: BlocProvider(
        create: (context) =>
            SpecialtiesCubit(getit.get<SpecialtiesRepo>())..getSpecialties(),
        child: BlocBuilder<SpecialtiesCubit, SpecialtiesState>(
          builder: (context, state) {
            if (state is SpecialtiesSuccess) {
              Future<void> onRefresh() async {
                await context.read<SpecialtiesCubit>().getSpecialties();
              }

              return RefreshIndicator(
                onRefresh: onRefresh,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: state.specialties.specializations?.length ?? 0,
                    itemBuilder: (context, index) {
                      final specialty =
                          state.specialties.specializations![index];
                      return SpecialtyWidget(specialty: specialty);
                    },
                  ),
                ),
              );
            } else if (state is SpecialtiesError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg.tr(context),
                onRetry: () {
                  context.read<SpecialtiesCubit>().getSpecialties();
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
