import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointments_model.dart';
import 'package:tabiby/features/user_app/user_appointments/data/repos/rating/rating_repo.dart';
import 'package:tabiby/features/user_app/user_appointments/presentation/view-model/rating/rating_cubit.dart';
import 'package:tabiby/features/user_app/user_appointments/presentation/view/appointment_details_screen.dart';

import 'rating_dialog.dart';

class AppointmentItem extends StatelessWidget {
  const AppointmentItem({
    super.key,
    required this.appointment,
    required this.status,
  });

  final Appointment appointment;
  final String status;

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (BuildContext context) =>
              RatingCubit(getit.get<RatingRepo>()),
          child: AppointmentRatingDialog(appointmentId: appointment.id!),
        );
      },
    );
  }

  Future<void> _openDetailsScreen(BuildContext context) async {
    final int? appointmentId = appointment.id;
    if (appointmentId == null) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppointmentDetailsScreen(appointmentId: appointmentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? parsedDate = _parseDate(appointment.date);
    final Color accentColor = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200Color),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateTile(parsedDate: parsedDate, accentColor: accentColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _weekdayLabel(context, parsedDate),
                          style: const TextStyle(
                            color: AppColors.titleColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _fullDateLabel(parsedDate),
                          style: TextStyle(
                            color: AppColors.grey600Color,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _StatusChip(
                  label: status.tr(context),
                  accentColor: accentColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lighterSurfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryColors.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColors.withValues(alpha: 0.15),
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: appointment.doctor?.img,
                        placeholderAsset: AssetsData.defaultDoctorProfile,
                        height: 68,
                        width: 68,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctor?.name ?? "--",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.titleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointment.doctor?.specialty?.name ?? "--",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.grey600Color,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoChip(
                              icon: Icons.access_time_rounded,
                              label: appointment.time ?? '--:--',
                              accentColor: AppColors.primaryColors,
                            ),
                            _InfoChip(
                              icon: Icons.star_rounded,
                              label:
                                  appointment.doctor?.rate?.toString() ?? '--',
                              accentColor: AppColors.warningAccentColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                if (appointment.id != null)
                  _ActionButton(
                    label: 'details'.tr(context),
                    icon: Icons.arrow_outward_rounded,
                    onTap: () => _openDetailsScreen(context),
                    filled: true,
                  ),
                if (status == 'completed')
                  _ActionButton(
                    label: 'rate'.tr(context),
                    icon: Icons.star_rate_rounded,
                    onTap: () => _showRatingDialog(context),
                    filled: false,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  String _weekdayLabel(BuildContext context, DateTime? parsedDate) {
    if (parsedDate == null) {
      return '--';
    }
    return DateFormat('EEEE').format(parsedDate).toLowerCase().tr(context);
  }

  String _fullDateLabel(DateTime? parsedDate) {
    if (parsedDate == null) {
      return '--';
    }
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  Color _statusColor() {
    switch (status) {
      case 'completed':
        return AppColors.primaryColors;
      case 'canceled':
        return AppColors.dangerSoftColor;
      default:
        return AppColors.warningAccentColor;
    }
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.parsedDate, required this.accentColor});

  final DateTime? parsedDate;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            parsedDate == null ? '--' : DateFormat('dd').format(parsedDate!),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: accentColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            parsedDate == null
                ? '--'
                : DateFormat('MMM').format(parsedDate!).toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: accentColor.withValues(alpha: 0.9),
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: accentColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.grey800Color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: filled
              ? AppColors.primaryColors
              : AppColors.primaryColors.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: filled
              ? null
              : Border.all(
                  color: AppColors.primaryColors.withValues(alpha: 0.18),
                ),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.primaryColors.withValues(alpha: 0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: filled ? AppColors.whiteColor : AppColors.primaryColors,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: filled ? AppColors.whiteColor : AppColors.primaryColors,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
