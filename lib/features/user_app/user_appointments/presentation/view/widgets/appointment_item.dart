import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointments_model.dart';

import '../../../../../../core/utils/assets_data.dart';
import '../../../../../../core/widgets/custom_image_widget.dart';
import '../../../data/repos/rating/rating_repo.dart';
import '../../view-model/rating/rating_cubit.dart';
import 'rating_dialog.dart';

class AppointmentItem extends StatelessWidget {
  final Appointment appointment;
  final String status;

  const AppointmentItem({
    super.key,
    required this.appointment,
    required this.status,
  });
  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (context) => RatingCubit(getit.get<RatingRepo>()),
          child: AppointmentRatingDialog(appointmentId: appointment.id!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(appointment.date!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('dd').format(parsedDate),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColors,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                DateFormat('EEEE').format(parsedDate).toLowerCase().tr(context),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Spacer(),
            if (status == 'completed')
              TextButton.icon(
                onPressed: () {
                  _showRatingDialog(context);
                },
                icon: Icon(
                  Icons.star_rate_rounded,
                  size: 18,
                  color: AppColors.primaryColors,
                ),
                label: Text(
                  'rate'.tr(context),
                  style: TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (appointment.doctorNote != null)
              TextButton(
                onPressed: () {
                  _showDetailsDialog(context);
                },
                child: Text(
                  'see_more'.tr(context),
                  style: TextStyle(
                    color: AppColors.primaryColors,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: CustomImageWidget(
                imageUrl: appointment.doctor!.img,
                placeholderAsset: AssetsData.defaultDoctorProfile,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctor!.name ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.doctor!.specialty!.name ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F3F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${"took_it_at".tr(context)} ${appointment.time}',
                      style: const TextStyle(
                        color: Color(0xFF79BCA4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            Row(
              children: [
                Text(
                  appointment.doctor!.rate.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.amber, size: 20),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE0E0E0), thickness: 1, height: 1),
      ],
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        // 1. Transparent background to let the custom shadow shine
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 2. Title (Centered & Styled like Rating Dialog)
              Text(
                "details".tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColors,
                ),
              ),
              const SizedBox(height: 24),

              // 3. Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Doctor Notes Section
                      if (appointment.doctorNote?.note != null &&
                          appointment.doctorNote!.note!.isNotEmpty)
                        _buildStyledDetailSection(
                          context,
                          icon: Icons.note_alt_rounded,
                          title: "doctor_notes".tr(context),
                          content: appointment.doctorNote!.note!,
                        ),

                      if (appointment.doctorNote?.note != null &&
                          appointment.doctorNote!.prescription != null)
                        const SizedBox(height: 16),

                      // Prescription Section
                      if (appointment.doctorNote?.prescription != null &&
                          appointment.doctorNote!.prescription!.isNotEmpty)
                        _buildStyledDetailSection(
                          context,
                          icon: Icons.medication_rounded,
                          title: 'prescription'.tr(context),
                          content: appointment.doctorNote!.prescription!,
                        ),

                      // Fallback if empty
                      if ((appointment.doctorNote?.note == null ||
                              appointment.doctorNote!.note!.isEmpty) &&
                          (appointment.doctorNote?.prescription == null ||
                              appointment.doctorNote!.prescription!.isEmpty))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "no_details_available".tr(context),
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Big "Close" Button (Matches Submit Button)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColors,
                    elevation: 0, // Flat or low elevation looks cleaner here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'close'.tr(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget that matches the "Comment" box style
  Widget _buildStyledDetailSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryColors, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Content Text
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
