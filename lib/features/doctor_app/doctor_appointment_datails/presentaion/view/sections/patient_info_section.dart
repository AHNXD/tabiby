import 'package:flutter/material.dart';
import 'package:tabiby/core/models/medical_record_attachment.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';

import '../../../data/models/doctor_appointment_details_model.dart';
import '../widgets/appointment_details_card.dart';

class PatientInfoSection extends StatelessWidget {
  const PatientInfoSection({super.key, required this.appointmentDetails});

  final DoctorAppointmentDetailsModel appointmentDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "patient_information".tr(context),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primaryColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        AppointmentDetailsCard(appointmentDetails: appointmentDetails),
        if (appointmentDetails.attachedXray != null ||
            appointmentDetails.attachedLabResult != null) ...[
          const SizedBox(height: 16),
          Text(
            'attached_medical_records'.tr(context),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryColors,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (appointmentDetails.attachedXray != null)
            _AttachmentCard(
              title: 'attached_xray'.tr(context),
              attachment: appointmentDetails.attachedXray!,
            ),
          if (appointmentDetails.attachedXray != null &&
              appointmentDetails.attachedLabResult != null)
            const SizedBox(height: 12),
          if (appointmentDetails.attachedLabResult != null)
            _AttachmentCard(
              title: 'attached_lab_result'.tr(context),
              attachment: appointmentDetails.attachedLabResult!,
            ),
        ],
      ],
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({required this.title, required this.attachment});

  final String title;
  final MedicalRecordAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final bool canShow = attachment.url != null && attachment.url!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: canShow ? () => _showAttachment(context) : null,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            title == 'attached_xray'.tr(context)
                ? Icons.image_outlined
                : Icons.science_outlined,
            color: AppColors.primaryColors,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            attachment.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        trailing: FilledButton.icon(
          onPressed: canShow ? () => _showAttachment(context) : null,
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: Text('show'.tr(context)),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryColors,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAttachment(BuildContext context) async {
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
}
