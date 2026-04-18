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
    final List<MedicalRecordAttachment> attachedRecords =
        appointmentDetails.visibleMedicalRecords;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "patient_information".tr(context),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primaryColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        AppointmentDetailsCard(appointmentDetails: appointmentDetails),
        if (attachedRecords.isNotEmpty) ...<Widget>[
          const SizedBox(height: 16),
          Text(
            'attached_medical_records'.tr(context),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryColors,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.generate(attachedRecords.length, (int index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == attachedRecords.length - 1 ? 0 : 12,
              ),
              child: _AttachmentCard(attachment: attachedRecords[index]),
            );
          }),
        ],
      ],
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({required this.attachment});

  final MedicalRecordAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final bool canShow = attachment.url != null && attachment.url!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
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
          child: Icon(_iconForType(), color: AppColors.primaryColors, size: 24),
        ),
        title: Text(
          attachment.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _typeLabel(context),
                style: TextStyle(
                  color: AppColors.grey800Color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if ((attachment.recordDate ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    attachment.recordDate!,
                    style: TextStyle(color: AppColors.grey700Color),
                  ),
                ),
              if ((attachment.sourceLabel ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    attachment.sourceLabel!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.grey700Color),
                  ),
                ),
            ],
          ),
        ),
        trailing: FilledButton.icon(
          onPressed: canShow ? () => _showAttachment(context) : null,
          icon: const Icon(Icons.visibility_outlined, size: 18),
          label: Text('show'.tr(context)),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryColors,
            foregroundColor: AppColors.whiteColor,
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
      messages(
        context,
        'cannot_show_medical_file'.tr(context),
        AppColors.redColor,
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: AppColors.blackColor,
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              foregroundColor: AppColors.whiteColor,
              elevation: 0,
              title: Text(
                attachment.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Text(
                      'medical_image_zoom_hint'.tr(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.white70Color),
                    ),
                  ),
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 5,
                      panEnabled: true,
                      child: Center(
                        child: CustomImageWidget(
                          imageUrl: url,
                          placeholderAsset: AssetsData.defaultCenter,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _iconForType() {
    switch (attachment.type?.toLowerCase()) {
      case 'lab':
      case 'lab_result':
        return Icons.science_outlined;
      case 'radiology':
      case 'xray':
      case 'radiology_result':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  String _typeLabel(BuildContext context) {
    switch (attachment.type?.toLowerCase()) {
      case 'lab':
      case 'lab_result':
        return 'attached_lab_result'.tr(context);
      case 'radiology':
      case 'xray':
      case 'radiology_result':
        return 'attached_xray'.tr(context);
      default:
        return 'attached_medical_records'.tr(context);
    }
  }
}
