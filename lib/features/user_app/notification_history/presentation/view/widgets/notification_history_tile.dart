import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';

import '../../../data/models/notification_history_item.dart';

class NotificationHistoryTile extends StatelessWidget {
  const NotificationHistoryTile({
    super.key,
    required this.notification,
    required this.onTap,
    this.isProcessing = false,
  });

  final NotificationHistoryItem notification;
  final VoidCallback onTap;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final bool canMarkAsRead = !notification.isRead && !isProcessing;
    final _NotificationPalette palette = _paletteFor(notification);
    final String formattedType = _formatType(notification.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: AppColors.transparentColor,
        child: InkWell(
          onTap: canMarkAsRead ? onTap : null,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  palette.backgroundColor,
                  palette.backgroundColor.withValues(alpha: 0.96),
                  AppColors.whiteColor,
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.borderColor),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -24,
                    right: -18,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.accentColor.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -34,
                    left: -10,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.accentColor.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    palette.accentColor,
                                    palette.accentColor.withValues(alpha: 0.78),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: palette.accentColor.withValues(
                                      alpha: 0.24,
                                    ),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _resolveIcon(),
                                color: palette.iconColor,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (formattedType.isNotEmpty) ...<Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: palette.badgeBackgroundColor,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        formattedType,
                                        style: TextStyle(
                                          color: palette.badgeTextColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                  Text(
                                    notification.title,
                                    style: const TextStyle(
                                      color: AppColors.titleColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.schedule_rounded,
                                        size: 15,
                                        color: AppColors.grey600Color,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _formatDate(
                                            context,
                                            notification.createdAt,
                                          ),
                                          style: TextStyle(
                                            color: AppColors.grey700Color,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (isProcessing)
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    palette.accentColor,
                                  ),
                                ),
                              )
                            else
                              _StatusChip(
                                label: notification.isRead
                                    ? 'notifications_read'.tr(context)
                                    : 'notifications_unread'.tr(context),
                                backgroundColor: palette.statusBackgroundColor,
                                textColor: palette.statusTextColor,
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: palette.outlineSoftColor),
                          ),
                          child: Text(
                            notification.body,
                            style: TextStyle(
                              color: AppColors.grey800Color,
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            if (notification.appointmentId != null)
                              _MetaChip(
                                icon: Icons.event_note_outlined,
                                label:
                                    '${'appointment'.tr(context)} #${notification.appointmentId}',
                                backgroundColor: AppColors.whiteColor,
                                iconColor: palette.accentColor,
                                textColor:
                                    AppColors.forestNotificationTextColor,
                              ),
                            if (notification.isRead &&
                                notification.readAt != null)
                              _MetaChip(
                                icon: Icons.done_all_rounded,
                                label:
                                    '${'notifications_read'.tr(context)} • ${_formatShortDate(context, notification.readAt!)}',
                                backgroundColor: AppColors.whiteColor,
                                iconColor: palette.badgeTextColor,
                                textColor:
                                    AppColors.forestNotificationTextColor,
                              ),
                            if (!notification.isRead)
                              _ActionChip(
                                icon: Icons.touch_app_rounded,
                                label: 'notifications_mark_read_hint'.tr(
                                  context,
                                ),
                                backgroundColor: palette.accentColor,
                                textColor: palette.iconColor,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime dateTime) {
    final String locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMM yyyy • hh:mm a', locale).format(dateTime);
  }

  String _formatShortDate(BuildContext context, DateTime dateTime) {
    final String locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMM • hh:mm a', locale).format(dateTime);
  }

  String _formatType(String type) {
    if (type.isEmpty) {
      return '';
    }

    final List<String> words = type
        .split('_')
        .where((String word) => word.isNotEmpty)
        .map(
          (String word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .toList();

    return words.join(' ');
  }

  IconData _resolveIcon() {
    if (notification.isRead) {
      return Icons.drafts_outlined;
    }

    final String normalized = notification.type.toLowerCase();
    if (normalized.contains('appointment') ||
        notification.appointmentId != null) {
      return Icons.event_available_rounded;
    }
    if (normalized.contains('cancel') || normalized.contains('reject')) {
      return Icons.event_busy_rounded;
    }
    if (normalized.contains('success') || normalized.contains('approve')) {
      return Icons.verified_rounded;
    }
    if (normalized.contains('reminder')) {
      return Icons.alarm_rounded;
    }

    return Icons.mark_email_unread_outlined;
  }

  _NotificationPalette _paletteFor(NotificationHistoryItem item) {
    final String normalized = item.type.toLowerCase();
    Color accentColor = AppColors.primaryColors;

    if (normalized.contains('cancel') || normalized.contains('reject')) {
      accentColor = AppColors.dangerMutedColor;
    } else if (normalized.contains('appointment') ||
        item.appointmentId != null ||
        normalized.contains('reminder')) {
      accentColor = AppColors.secColors;
    } else if (normalized.contains('success') ||
        normalized.contains('approve')) {
      accentColor = AppColors.successMutedColor;
    } else if (normalized.contains('warning')) {
      accentColor = AppColors.warningAccentColor;
    }

    if (item.isRead) {
      return _NotificationPalette(
        accentColor: accentColor.withValues(alpha: 0.84),
        backgroundColor: AppColors.notificationSurfaceColor,
        borderColor: AppColors.notificationBorderColor,
        shadowColor: AppColors.blackColor.withValues(alpha: 0.03),
        badgeBackgroundColor: AppColors.grey100Color,
        badgeTextColor: AppColors.notificationTextColor,
        statusBackgroundColor: AppColors.notificationBadgeSurfaceColor,
        statusTextColor: AppColors.notificationTextColor,
        outlineSoftColor: AppColors.notificationOutlineColor,
        iconColor: AppColors.whiteColor,
      );
    }

    return _NotificationPalette(
      accentColor: accentColor,
      backgroundColor: accentColor.withValues(alpha: 0.10),
      borderColor: accentColor.withValues(alpha: 0.18),
      shadowColor: accentColor.withValues(alpha: 0.14),
      badgeBackgroundColor: accentColor.withValues(alpha: 0.12),
      badgeTextColor: accentColor,
      statusBackgroundColor: accentColor.withValues(alpha: 0.12),
      statusTextColor: accentColor,
      outlineSoftColor: accentColor.withValues(alpha: 0.14),
      iconColor: AppColors.whiteColor,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: textColor),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderColor.withValues(alpha: 0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationPalette {
  const _NotificationPalette({
    required this.accentColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.shadowColor,
    required this.badgeBackgroundColor,
    required this.badgeTextColor,
    required this.statusBackgroundColor,
    required this.statusTextColor,
    required this.outlineSoftColor,
    required this.iconColor,
  });

  final Color accentColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
  final Color badgeBackgroundColor;
  final Color badgeTextColor;
  final Color statusBackgroundColor;
  final Color statusTextColor;
  final Color outlineSoftColor;
  final Color iconColor;
}
