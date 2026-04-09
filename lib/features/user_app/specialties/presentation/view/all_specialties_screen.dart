import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/no_data.dart';
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
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: "all_specialties".tr(context)),
      body: BlocProvider(
        create: (context) =>
            SpecialtiesCubit(getit.get<SpecialtiesRepo>())..getSpecialties(),
        child: BlocBuilder<SpecialtiesCubit, SpecialtiesState>(
          builder: (context, state) {
            if (state is SpecialtiesSuccess) {
              Future<void> onRefresh() async {
                await context.read<SpecialtiesCubit>().getSpecialties();
              }

              if ((state.specialties.specializations ?? []).isEmpty) {
                return NoDataWidget(
                  title: "no_data_title".tr(context),
                  subtitle: "no_data_subtitle".tr(context),
                );
              }
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        child: _SpecialtiesOverviewCard(
                          count: state.specialties.specializations?.length ?? 0,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final specialty =
                                state.specialties.specializations![index];
                            return SpecialtyWidget(specialty: specialty);
                          },
                          childCount:
                              state.specialties.specializations?.length ?? 0,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 20,
                              childAspectRatio: 0.8,
                            ),
                      ),
                    ),
                  ],
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

class _SpecialtiesOverviewCard extends StatelessWidget {
  const _SpecialtiesOverviewCard({required this.count});

  final int count;

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 18,
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
            bottom: 16,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secColors.withValues(alpha: 0.035),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.category_outlined,
                        color: AppColors.primaryColors,
                        size: 28,
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
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: AppColors.primaryColors,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'all_specialties'.tr(context),
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'find_your_doctor'.tr(context),
                  style: TextStyle(color: Colors.grey.shade700, height: 1.45),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _SpecialtyOverviewChip(
                      icon: Icons.grid_view_rounded,
                      label: 'all_specialties'.tr(context),
                    ),
                    _SpecialtyOverviewChip(
                      icon: Icons.medical_services_outlined,
                      label: 'popular_doctors'.tr(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialtyOverviewChip extends StatelessWidget {
  const _SpecialtyOverviewChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryColors),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1F2C28),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
