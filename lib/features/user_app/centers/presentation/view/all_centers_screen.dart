import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/no_data.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/buttom_loader.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../center_details/presentation/view/center_details_screen.dart';
import '../../data/repos/centers_repo.dart';
import '../view_model/centers_cubit.dart';
import 'widgets/center_card.dart';

class AllCentersScreen extends StatefulWidget {
  static const String routeName = "/centers";

  const AllCentersScreen({super.key});

  @override
  State<AllCentersScreen> createState() => _AllCentersScreenState();
}

class _AllCentersScreenState extends State<AllCentersScreen> {
  final ScrollController _controller = ScrollController();
  late CentersCubit _centersCubit;

  @override
  void initState() {
    super.initState();
    _centersCubit = CentersCubit(getit.get<CentersRepo>());

    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_centersCubit.isRefreshing) {
        _centersCubit.getCenters(loadMore: true);
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
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: "all_popular_centers".tr(context)),
      body: BlocProvider(
        create: (BuildContext context) {
          return CentersCubit(getit.get<CentersRepo>())..getCenters();
        },
        child: BlocBuilder<CentersCubit, CentersState>(
          builder: (context, state) {
            if (state is CentersSuccess) {
              Future<void> onRefresh() async {
                await context.read<CentersCubit>().refreshCenters();
              }

              if (state.centers.isEmpty) {
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
                        child: _CentersOverviewCard(
                          count: state.centers.length,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final center = state.centers[index];
                          return CenterCard(
                            center: center,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CenterDetailsScreen(centerID: center.id!),
                                ),
                              );
                            },
                          );
                        }, childCount: state.centers.length),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.78,
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
            } else if (state is CentersError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<CentersCubit>().getCenters();
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

class _CentersOverviewCard extends StatelessWidget {
  const _CentersOverviewCard({required this.count});

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
                        Icons.local_hospital_outlined,
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
                  'all_popular_centers'.tr(context),
                  style: const TextStyle(
                    color: Color(0xFF1F2C28),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'center_details'.tr(context),
                  style: TextStyle(color: Colors.grey.shade700, height: 1.45),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _CenterOverviewChip(
                      icon: Icons.location_on_outlined,
                      label: 'center_details'.tr(context),
                    ),
                    _CenterOverviewChip(
                      icon: Icons.apartment_rounded,
                      label: 'all_popular_centers'.tr(context),
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

class _CenterOverviewChip extends StatelessWidget {
  const _CenterOverviewChip({required this.icon, required this.label});

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
