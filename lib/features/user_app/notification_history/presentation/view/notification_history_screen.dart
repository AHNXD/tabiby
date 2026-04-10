import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';

import '../../data/models/notification_history_item.dart';
import '../view-model/notification_history_cubit.dart';
import 'widgets/notification_history_tile.dart';

class NotificationHistoryScreen extends StatefulWidget {
  const NotificationHistoryScreen({super.key});

  static const String routeName = '/notification_history';

  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState extends State<NotificationHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<NotificationHistoryCubit>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: CustomAppbar(title: 'notifications'.tr(context)),
      body: SafeArea(
        child: BlocConsumer<NotificationHistoryCubit, NotificationHistoryState>(
          listenWhen:
              (
                NotificationHistoryState previous,
                NotificationHistoryState current,
              ) => previous.readStatus != current.readStatus,
          listener: (BuildContext context, NotificationHistoryState state) {
            if (state.readStatus == NotificationReadStatus.failure &&
                state.actionErrorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.actionErrorMessage.tr(context))),
              );
              context.read<NotificationHistoryCubit>().clearReadStatus();
            }

            if (state.readStatus == NotificationReadStatus.success) {
              context.read<NotificationHistoryCubit>().clearReadStatus();
            }
          },
          builder: (BuildContext context, NotificationHistoryState state) {
            if (state.isInitialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == NotificationHistoryStatus.failure &&
                state.notifications.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: CustomErrorWidget(
                    textColor: Colors.black,
                    errorMessage: state.errorMessage.tr(context),
                    onRetry: () => context
                        .read<NotificationHistoryCubit>()
                        .loadNotifications(force: true),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<NotificationHistoryCubit>()
                  .loadNotifications(force: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                children: <Widget>[
                  _NotificationOverviewCard(
                    totalCount: state.notifications.length,
                    unreadCount: state.unreadCount,
                  ),
                  const SizedBox(height: 18),
                  if (state.notifications.isEmpty)
                    const _EmptyNotificationsState()
                  else
                    ...state.notifications.map(
                      (
                        NotificationHistoryItem notification,
                      ) => NotificationHistoryTile(
                        notification: notification,
                        isProcessing:
                            state.processingNotificationId == notification.id &&
                            state.readStatus == NotificationReadStatus.loading,
                        onTap: () => context
                            .read<NotificationHistoryCubit>()
                            .markAsRead(notification.id),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotificationOverviewCard extends StatelessWidget {
  const _NotificationOverviewCard({
    required this.totalCount,
    required this.unreadCount,
  });

  final int totalCount;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFA),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.notifications_active_outlined,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.primaryColors.withValues(alpha: 0.16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.mark_email_unread_outlined,
                        color: AppColors.primaryColors,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        unreadCount.toString(),
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
              'notifications'.tr(context),
              style: const TextStyle(
                color: Color(0xFF1F2C28),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'notifications_history_hint'.tr(context),
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: _OverviewStatCard(
                    icon: Icons.mail_outline_rounded,
                    label: 'notifications_total'.tr(context),
                    value: totalCount.toString(),
                    accentColor: AppColors.primaryColors,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OverviewStatCard(
                    icon: Icons.mark_email_unread_outlined,
                    label: 'notifications_unread'.tr(context),
                    value: unreadCount.toString(),
                    accentColor: const Color(0xFFE7A423),
                  ),
                ),
              ],
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2C28),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotificationsState extends StatelessWidget {
  const _EmptyNotificationsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryColors.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primaryColors,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'notifications_empty_title'.tr(context),
            style: const TextStyle(
              color: Color(0xFF1F2C28),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'notifications_empty_subtitle'.tr(context),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
