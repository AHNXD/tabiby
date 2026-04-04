import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/buttom_loader.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../data/repos/doctors_repo.dart';
import '../view_model/doctor_cubit.dart';
import 'widgets/doctor_card.dart';

class AllDoctorsScreen extends StatefulWidget {
  static const String routeName = "/doctors";

  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  final ScrollController _controller = ScrollController();
  int? centerID;
  int? specialtyID;
  late DoctorsCubit _doctorsCubit;

  @override
  void initState() {
    super.initState();
    _doctorsCubit = DoctorsCubit(getit.get<DoctorsRepo>());

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_doctorsCubit.isRefreshing) {
        _doctorsCubit.getDoctors(centerID, specialtyID, loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)!.settings.arguments;
    final Map<String, dynamic> args =
        (arguments != null && arguments is Map<String, dynamic>)
        ? arguments
        : {};

    centerID = args['centerID'];
    specialtyID = args['specialtyID'];
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: "all_popular_doctors".tr(context)),
      body: BlocProvider(
        create: (BuildContext context) {
          return _doctorsCubit..getDoctors(centerID, specialtyID);
        },
        child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsSuccess) {
              Future<void> onRefresh() async {
                await context.read<DoctorsCubit>().refreshDoctors(
                  centerID,
                  specialtyID,
                );
              }

              if (state.doctors.isEmpty) {
                return NoDataWidget(
                  title: "no_data_title".tr(context),
                  subtitle: "no_data_subtitle".tr(context),
                );
              }
              return RefreshIndicator(
                onRefresh: onRefresh,
                child: CustomScrollView(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        child: _DoctorsOverviewCard(
                          count: state.doctors.length,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return DoctorCard(doctor: state.doctors[index]);
                        }, childCount: state.doctors.length),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.74,
                            ),
                      ),
                    ),
                    if (state.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 18),
                          child: BottomLoader(),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is DoctorsError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<DoctorsCubit>().getDoctors(
                    centerID,
                    specialtyID,
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColors,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _DoctorsOverviewCard extends StatelessWidget {
  const _DoctorsOverviewCard({required this.count});

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
                        Icons.medical_services_outlined,
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
                  'all_popular_doctors'.tr(context),
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'doctor_details'.tr(context),
                  style: TextStyle(color: Colors.grey.shade700, height: 1.45),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _OverviewChip(
                      icon: Icons.star_outline_rounded,
                      label: 'rate'.tr(context),
                    ),
                    _OverviewChip(
                      icon: Icons.verified_user_outlined,
                      label: 'available'.tr(context),
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

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.icon, required this.label});

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
