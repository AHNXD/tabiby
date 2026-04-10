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

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canMarkAsRead ? onTap : null,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? Colors.white
                  : const Color(0xFFF0F8F4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: notification.isRead
                    ? AppColors.borderColor
                    : AppColors.primaryColors.withValues(alpha: 0.18),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
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
                        color: notification.isRead
                            ? Colors.grey.shade100
                            : AppColors.primaryColors.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        notification.isRead
                            ? Icons.drafts_outlined
                            : Icons.mark_email_unread_outlined,
                        color: notification.isRead
                            ? Colors.grey.shade700
                            : AppColors.primaryColors,
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
                              color: Color(0xFF1F2C28),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatDate(context, notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (isProcessing)
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.2),
                      )
                    else
                      _StatusChip(
                        label: notification.isRead
                            ? 'notifications_read'.tr(context)
                            : 'notifications_unread'.tr(context),
                        backgroundColor: notification.isRead
                            ? Colors.grey.shade100
                            : AppColors.primaryColors.withValues(alpha: 0.12),
                        textColor: notification.isRead
                            ? Colors.grey.shade700
                            : AppColors.primaryColors,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  notification.body,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    _MetaChip(
                      icon: Icons.sell_outlined,
                      label: _formatType(notification.type),
                    ),
                    if (notification.appointmentId != null)
                      _MetaChip(
                        icon: Icons.event_note_outlined,
                        label:
                            '${'appointment'.tr(context)} #${notification.appointmentId}',
                      ),
                    if (!notification.isRead)
                      Text(
                        'notifications_mark_read_hint'.tr(context),
                        style: TextStyle(
                          color: AppColors.primaryColors,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
