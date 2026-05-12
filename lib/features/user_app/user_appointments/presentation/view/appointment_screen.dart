import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/user_appointments/data/repos/my_appointments/my_appointments_repo.dart';
import 'package:tabiby/features/user_app/user_appointments/presentation/view-model/my_appointments/my_appointments_cubit.dart';

import 'widgets/appointment_list.dart';
import 'widgets/colored_text_bar.dart';

class UserAppointmentScreen extends StatelessWidget {
  static const String routeName = "/user_appointments";

  const UserAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.appBackgroundColor,
        appBar: CustomAppbar(
          title: 'my_appointments'.tr(context),
          showBackButton: false,
        ),
        body: BlocProvider(
          lazy: false,
          create: (context) =>
              MyAppointmentsCubit(getit.get<MyAppointmentsRepo>())
                ..getMyAppointments(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: BlocConsumer<MyAppointmentsCubit, MyAppointmentsState>(
                listener: (context, state) {
                  if (state is! MyAppointmentsSuccess) {
                    return;
                  }

                  if (state.actionMessage.isNotEmpty) {
                    messages(
                      context,
                      state.actionMessage.tr(context),
                      AppColors.greenColor,
                    );
                  }

                  if (state.actionErrorMessage.isNotEmpty) {
                    messages(
                      context,
                      state.actionErrorMessage.tr(context),
                      AppColors.redColor,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is MyAppointmentsSuccess) {
                    final int completedCount =
                        state.myAppointments.completed?.length ?? 0;
                    final int pendingCount =
                        state.myAppointments.pending?.length ?? 0;
                    final int canceledCount =
                        state.myAppointments.canceled?.length ?? 0;

                    Future<void> onRefresh() async {
                      await context
                          .read<MyAppointmentsCubit>()
                          .getMyAppointments();
                    }

                    return NestedScrollView(
                      physics: const BouncingScrollPhysics(),
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: _AppointmentOverviewCard(
                                completedCount: completedCount,
                                pendingCount: pendingCount,
                                canceledCount: canceledCount,
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _PinnedTabBarDelegate(
                              child: const ColoredTextTabBar(),
                            ),
                          ),
                        ];
                      },
                      body: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TabBarView(
                          children: [
                            RefreshIndicator(
                              onRefresh: onRefresh,
                              child: AppointmentList(
                                appointments:
                                    state.myAppointments.completed ?? [],
                                status: "completed",
                              ),
                            ),
                            RefreshIndicator(
                              onRefresh: onRefresh,
                              child: AppointmentList(
                                appointments:
                                    state.myAppointments.pending ?? [],
                                status: "pending",
                                cancelingAppointmentId:
                                    state.cancelingAppointmentId,
                                onCancelAppointment: (appointment) {
                                  context
                                      .read<MyAppointmentsCubit>()
                                      .cancelAppointment(appointment);
                                },
                              ),
                            ),
                            RefreshIndicator(
                              onRefresh: onRefresh,
                              child: AppointmentList(
                                appointments:
                                    state.myAppointments.canceled ?? [],
                                status: "canceled",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is MyAppointmentsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: CustomErrorWidget(
                          textColor: AppColors.blackColor,
                          errorMessage: state.errorMsg,
                          onRetry: () => context
                              .read<MyAppointmentsCubit>()
                              .getMyAppointments(),
                        ),
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedTabBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 68;

  @override
  double get maxExtent => 68;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.appBackgroundColor,
      padding: const EdgeInsets.only(bottom: 8),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedTabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class _AppointmentOverviewCard extends StatelessWidget {
  const _AppointmentOverviewCard({
    required this.completedCount,
    required this.pendingCount,
    required this.canceledCount,
  });

  final int completedCount;
  final int pendingCount;
  final int canceledCount;

  @override
  Widget build(BuildContext context) {
    final int totalCount = completedCount + pendingCount + canceledCount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.softSurfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
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
            bottom: 36,
            child: Container(
              width: 130,
              height: 130,
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
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: AppColors.primaryColors,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.16,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.event_note_rounded,
                            color: AppColors.primaryColors,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            totalCount.toString(),
                            style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'my_appointments'.tr(context),
                  style: const TextStyle(
                    color: AppColors.titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${'pending'.tr(context)} • ${'finished'.tr(context)} • ${'canceled'.tr(context)}',
                  style: TextStyle(
                    color: AppColors.grey700Color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _OverviewStatCard(
                          icon: Icons.hourglass_top_rounded,
                          label: 'pending'.tr(context),
                          value: pendingCount.toString(),
                          accentColor: AppColors.warningAccentColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _OverviewStatCard(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'finished'.tr(context),
                          value: completedCount.toString(),
                          accentColor: AppColors.primaryColors,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _OverviewStatCard(
                          icon: Icons.cancel_outlined,
                          label: 'canceled'.tr(context),
                          value: canceledCount.toString(),
                          accentColor: AppColors.dangerSoftColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewStatCard extends StatelessWidget {
  const _OverviewStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 84),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.titleColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.grey600Color,
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
