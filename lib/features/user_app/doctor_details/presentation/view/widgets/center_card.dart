import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctor_details/data/models/doctor_model.dart';
import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/utils/functions.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';

class CenterCard extends StatelessWidget {
  final DoctorCenters center;

  const CenterCard({super.key, required this.center});

  @override
  Widget build(BuildContext context) {
    final schedules = center.daySchedules ?? const <DoctorCenterDay>[];
    final firstSchedule = schedules.isNotEmpty ? schedules.first : null;
    final firstTimeRange = _formatTimeRange(
      firstSchedule?.timeFrom ?? center.timeFrom,
      firstSchedule?.timeTo ?? center.timeTo,
    );
    final appointmentDuration =
        center.appointmentDurationMinutes ??
        firstSchedule?.appointmentDurationMinutes;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColors.withValues(alpha: 0.14),
                        AppColors.secColors.withValues(alpha: 0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomImageWidget(
                      imageUrl: center.image,
                      placeholderAsset: AssetsData.defaultCenter,
                      height: 58,
                      width: 58,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              center.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                                color: AppColors.titleColor,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColors.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              center.price != null
                                  ? '${center.price} ${"sy".tr(context)}'
                                  : 'free'.tr(context),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColors,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      if (appointmentDuration != null) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: AppColors.grey600Color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${'duration'.tr(context)}: $appointmentDuration ${'minutes'.tr(context)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.grey600Color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(
              height: 1,
              thickness: 0.5,
              color: AppColors.softBorderColor,
            ),
            const SizedBox(height: 12),

            if (schedules.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: schedules.where((day) => day.dayOfWeek != null).map(
                    (day) {
                      return _ScheduleChip(day: day);
                    },
                  ).toList(),
                ),
              )
            else if (center.days != null && center.days!.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: center.days!.map((dayIndex) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColors.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryColors.withValues(
                            alpha: 0.15,
                          ),
                        ),
                      ),
                      child: Text(
                        getDayName(dayIndex, context),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primaryColors.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "contact_for_days".tr(context),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String? _formatTimeRange(String? from, String? to) {
    if ((from == null || from.isEmpty) && (to == null || to.isEmpty)) {
      return null;
    }

    return '${from ?? '--:--'} - ${to ?? '--:--'}';
  }
}

class _ScheduleChip extends StatelessWidget {
  const _ScheduleChip({required this.day});

  final DoctorCenterDay day;

  @override
  Widget build(BuildContext context) {
    final timeRange = CenterCard._formatTimeRange(day.timeFrom, day.timeTo);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColors.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getDayName(day.dayOfWeek!, context),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primaryColors.withValues(alpha: 0.9),
              fontWeight: FontWeight.w700,
            ),
          ),
          if (timeRange != null) ...[
            const SizedBox(height: 2),
            Text(
              timeRange,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.grey600Color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
