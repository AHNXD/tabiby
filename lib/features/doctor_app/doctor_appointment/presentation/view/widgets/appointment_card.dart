import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';
import '../../../data/models/doctor_appointments_model.dart';
import '../../../../doctor_appointment_datails/presentaion/view/doctor_appointment_details_screen.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentData appointment;
  final Future<void> Function() onRefresh;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status color
    final status = appointment.status ?? 'pending';
    final Color statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparentColor,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoctorAppointmentDetailsScreen(
                  id: appointment.id,
                  status: status,
                ),
              ),
            );
            onRefresh();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // 1. Colored Status Strip
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 2. Patient Image with Border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.greyColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: appointment.patientImage,
                        placeholderAsset: AssetsData.defaultProfileImage,
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 3. Middle Content (Name, Center, Time)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Patient Name
                        Text(
                          appointment.patientName ??
                              'unknown_patient'.tr(context),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.black87Color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Center Name (with Icon)
                        if (appointment.centerName != null &&
                            appointment.centerName!.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.business_rounded,
                                size: 12,
                                color: AppColors.grey500Color,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  appointment.centerName!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.grey600Color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 4),

                        // Time Row
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: AppColors.grey500Color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.time ?? '--:--',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey600Color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 4. Right Side (Status Badge & Arrow)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status.tr(context),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Arrow Button Container
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.greyColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.grey600Color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.greenColor;
      case 'pending':
        return AppColors.orangeColor;
      case 'cancelled':
      case 'canceled':
        return AppColors.redColor;
      default:
        return AppColors.greyColor;
    }
  }
}
