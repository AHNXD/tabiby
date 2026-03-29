import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tabiby/core/Api_services/urls.dart';
import 'package:tabiby/core/models/medical_record_attachment.dart';
import 'package:tabiby/core/models/prescription_item.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/primary_button.dart';
import 'package:tabiby/core/widgets/secondry_button.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointments_model.dart';

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
    final DateTime parsedDate = DateTime.parse(appointment.date!);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColors.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('dd').format(parsedDate),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColors,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'MMM',
                        ).format(parsedDate).toUpperCase().tr(context),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColors.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat(
                    'EEEE',
                  ).format(parsedDate).toLowerCase().tr(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                if (status == 'completed')
                  _buildActionButton(
                    context,
                    label: 'rate'.tr(context),
                    icon: Icons.star_rate_rounded,
                    onTap: () => _showRatingDialog(context),
                  ),
                if (_hasDetails) ...[
                  if (status == 'completed') const SizedBox(width: 8),
                  _buildActionButton(
                    context,
                    label: 'details'.tr(context),
                    icon: Icons.info_outline_rounded,
                    onTap: () => _showDetailsDialog(context),
                    isOutlined: status == 'completed',
                  ),
                ],
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFEEEEEE),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: appointment.doctor!.img,
                      placeholderAsset: AssetsData.defaultDoctorProfile,
                      height: 60,
                      width: 60,
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
                        appointment.doctor!.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.doctor!.specialty!.name ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.time ?? '--:--',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment.doctor!.rate.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasDetails =>
      (appointment.doctorNote?.note?.isNotEmpty ?? false) ||
      (appointment.doctorNote?.prescription?.isNotEmpty ?? false) ||
      appointment.doctorNote!.prescriptionList.isNotEmpty ||
      appointment.xrayAttachment != null ||
      appointment.labResultAttachment != null;

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isOutlined
              ? Colors.transparent
              : AppColors.primaryColors.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: isOutlined
              ? Border.all(
                  color: AppColors.primaryColors.withValues(alpha: 0.3),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primaryColors),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryColors,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "details".tr(context),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColors,
                ),
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (appointment.doctorNote?.note?.isNotEmpty ?? false)
                        _buildStyledDetailSection(
                          context,
                          icon: Icons.note_alt_rounded,
                          title: "doctor_notes".tr(context),
                          content: appointment.doctorNote!.note!,
                        ),
                      if ((appointment.doctorNote?.note?.isNotEmpty ?? false) &&
                          _hasPrescriptionContent)
                        const SizedBox(height: 16),
                      if (_hasPrescriptionContent)
                        _buildPrescriptionSection(context),
                      if ((appointment.doctorNote?.note?.isNotEmpty ??
                              false || _hasPrescriptionContent) &&
                          _hasAttachments)
                        const SizedBox(height: 16),
                      if (_hasAttachments) _buildAttachmentsSection(context),
                      if (!_hasDetails)
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColors,
                    elevation: 0,
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

  bool get _hasPrescriptionContent =>
      (appointment.doctorNote?.prescription?.isNotEmpty ?? false) ||
      appointment.doctorNote!.prescriptionList.isNotEmpty;

  bool get _hasAttachments =>
      appointment.xrayAttachment != null ||
      appointment.labResultAttachment != null;

  Widget _buildPrescriptionSection(BuildContext context) {
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
          Row(
            children: [
              const Icon(
                Icons.medication_rounded,
                color: AppColors.primaryColors,
              ),
              const SizedBox(width: 10),
              Text(
                'prescription'.tr(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColors,
                ),
              ),
            ],
          ),
          if (appointment.doctorNote?.prescription?.isNotEmpty ?? false) ...[
            const SizedBox(height: 12),
            Text(
              appointment.doctorNote!.prescription!,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
          ],
          if (appointment.doctorNote!.prescriptionList.isNotEmpty) ...[
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: appointment.doctorNote!.prescriptionList.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final PrescriptionItem item =
                    appointment.doctorNote!.prescriptionList[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.drugName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildMetaLine(
                        context,
                        '${"dosage".tr(context)}: ${item.dosage}',
                      ),
                      _buildMetaLine(
                        context,
                        '${"start_date".tr(context)}: ${item.startDate}',
                      ),
                      _buildMetaLine(
                        context,
                        '${"end_date".tr(context)}: ${item.endDate}',
                      ),
                      _buildMetaLine(
                        context,
                        '${"frequency_per_day".tr(context)}: ${item.frequencyPerDay}',
                      ),
                      if (item.specialNotes.isNotEmpty)
                        _buildMetaLine(
                          context,
                          '${"special_notes".tr(context)}: ${item.specialNotes}',
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection(BuildContext context) {
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
          Row(
            children: [
              const Icon(
                Icons.attach_file_rounded,
                color: AppColors.primaryColors,
              ),
              const SizedBox(width: 10),
              Text(
                'attachments'.tr(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (appointment.xrayAttachment != null)
            _buildAttachmentCard(
              context,
              title: 'xray_file'.tr(context),
              attachment: appointment.xrayAttachment!,
            ),
          if (appointment.xrayAttachment != null &&
              appointment.labResultAttachment != null)
            const SizedBox(height: 10),
          if (appointment.labResultAttachment != null)
            _buildAttachmentCard(
              context,
              title: 'lab_file'.tr(context),
              attachment: appointment.labResultAttachment!,
            ),
        ],
      ),
    );
  }

  Widget _buildAttachmentCard(
    BuildContext context, {
    required String title,
    required MedicalRecordAttachment attachment,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: attachment.thumbnailUrl ?? attachment.url,
                  placeholderAsset: AssetsData.defaultCenter,
                  height: 58,
                  width: 58,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      attachment.title,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: Row(
              children: [
                Expanded(
                  child: SecondryButton(
                    fontSize: 16,
                    text: 'download'.tr(context),
                    onPressed: () => _downloadAttachment(context, attachment),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    fontSize: 16,
                    text: 'show'.tr(context),
                    onPressed: () => _showAttachment(context, attachment),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAttachment(
    BuildContext context,
    MedicalRecordAttachment attachment,
  ) async {
    final String? url = attachment.url;
    if (url == null || url.isEmpty) {
      messages(context, 'cannot_show_medical_file'.tr(context), Colors.red);
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        attachment.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomImageWidget(
                    imageUrl: url,
                    placeholderAsset: AssetsData.defaultCenter,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadAttachment(
    BuildContext context,
    MedicalRecordAttachment attachment,
  ) async {
    final String? url = attachment.url;
    if (url == null || url.isEmpty) {
      messages(context, 'medical_file_download_failed'.tr(context), Colors.red);
      return;
    }

    try {
      final Directory targetDirectory = Directory(
        '${Directory.systemTemp.path}/tabiby_downloads',
      );
      if (!targetDirectory.existsSync()) {
        targetDirectory.createSync(recursive: true);
      }

      final String safeTitle = attachment.title
          .replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_')
          .replaceAll(RegExp(r'_+'), '_');
      final String targetPath =
          '${targetDirectory.path}/${safeTitle.isEmpty ? 'attachment' : safeTitle}_${attachment.id ?? 0}.jpg';

      await getit.get<Dio>().download(Urls.fixUrl(url), targetPath);

      if (!context.mounted) {
        return;
      }

      messages(
        context,
        '${"medical_file_downloaded_to".tr(context)} $targetPath',
        Colors.green,
        msgTime: 4,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      messages(context, 'medical_file_download_failed'.tr(context), Colors.red);
    }
  }

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
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColors, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaLine(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade700, height: 1.4),
      ),
    );
  }
}
