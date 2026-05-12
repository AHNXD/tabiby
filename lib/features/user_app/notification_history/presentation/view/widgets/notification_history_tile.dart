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
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: palette.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.borderColor),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: palette.accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _resolveIcon(),
                            color: palette.accentColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  color: AppColors.titleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatDate(context, notification.createdAt),
                                style: TextStyle(
                                  color: AppColors.grey600Color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (formattedType.isNotEmpty) ...<Widget>[
                                const SizedBox(height: 8),
                                Text(
                                  formattedType,
                                  style: TextStyle(
                                    color: AppColors.grey600Color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (isProcessing)
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                palette.accentColor,
                              ),
                            ),
                          )
                        else if (!notification.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: palette.accentColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          Icon(
                            Icons.done_rounded,
                            color: AppColors.grey400Color,
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      notification.body,
                      style: TextStyle(
                        color: AppColors.grey800Color,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        if (notification.appointmentId != null)
                          _MetaChip(
                            icon: Icons.event_note_outlined,
                            label:
                                '${'appointment'.tr(context)} #${notification.appointmentId}',
                            backgroundColor: AppColors.grey100Color,
                            iconColor: AppColors.grey700Color,
                            textColor: AppColors.grey700Color,
                          ),
                        if (notification.isRead && notification.readAt != null)
                          _MetaChip(
                            icon: Icons.done_all_rounded,
                            label: _formatShortDate(
                              context,
                              notification.readAt!,
                            ),
                            backgroundColor: AppColors.grey100Color,
                            iconColor: AppColors.grey700Color,
                            textColor: AppColors.grey700Color,
                          ),
                        if (!notification.isRead)
                          _MetaChip(
                            icon: Icons.mark_email_unread_outlined,
                            label: 'notifications_unread'.tr(context),
                            backgroundColor: palette.accentColor.withValues(
                              alpha: 0.08,
                            ),
                            iconColor: palette.accentColor,
                            textColor: palette.accentColor,
                          ),
                      ],
                    ),
                  ],
                ),
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
        accentColor: accentColor.withValues(alpha: 0.72),
        backgroundColor: AppColors.whiteColor,
        borderColor: AppColors.grey200Color,
        shadowColor: AppColors.blackColor.withValues(alpha: 0.03),
      );
    }

    return _NotificationPalette(
      accentColor: accentColor,
      backgroundColor: AppColors.whiteColor,
      borderColor: accentColor.withValues(alpha: 0.18),
      shadowColor: accentColor.withValues(alpha: 0.05),
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
  });

  final Color accentColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color shadowColor;
}
