import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/models/medical_record_attachment.dart';
import 'package:tabiby/core/models/prescription_item.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/assets_data.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/core/widgets/custom_image_widget.dart';

import '../../data/models/appointment_details_model.dart';
import '../../data/repos/my_appointments/my_appointments_repo.dart';
import '../view-model/appointment_details/appointment_details_cubit.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final int appointmentId;

  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          AppointmentDetailsCubit(getit.get<MyAppointmentsRepo>())
            ..getAppointmentDetails(appointmentId),
      child: _AppointmentDetailsView(appointmentId: appointmentId),
    );
  }
}

class _AppointmentDetailsView extends StatelessWidget {
  const _AppointmentDetailsView({required this.appointmentId});

  final int appointmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softSurfaceMutedColor,
      appBar: CustomAppbar(title: 'appointment_details'.tr(context)),
      body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
        builder: (BuildContext context, AppointmentDetailsState state) {
          if (state is AppointmentDetailsLoading ||
              state is AppointmentDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentDetailsError) {
            return CustomErrorWidget(
              textColor: AppColors.blackColor,
              errorMessage: state.errorMsg,
              onRetry: () => context
                  .read<AppointmentDetailsCubit>()
                  .getAppointmentDetails(appointmentId),
            );
          }

          final AppointmentDetailsModel details =
              (state as AppointmentDetailsSuccess).details;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _HeaderCard(details: details),
                  const SizedBox(height: 16),
                  _DoctorCard(details: details),
                  const SizedBox(height: 16),
                  _SummaryCard(details: details),
                  if ((details.patientNote ?? '')
                      .trim()
                      .isNotEmpty) ...<Widget>[
                    const SizedBox(height: 16),
                    _TextSectionCard(
                      title: 'patient_note'.tr(context),
                      icon: Icons.note_alt_outlined,
                      content: details.patientNote!,
                    ),
                  ],
                  if ((details.doctorNote ?? '').trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 16),
                    _TextSectionCard(
                      title: 'doctor_notes'.tr(context),
                      icon: Icons.sticky_note_2_outlined,
                      content: details.doctorNote!,
                    ),
                  ],
                  if (details.diagnosis?.diagnosisName?.trim().isNotEmpty ??
                      false) ...<Widget>[
                    const SizedBox(height: 16),
                    _DiagnosisCard(diagnosis: details.diagnosis!),
                  ],
                  if (details.hasCompletionContent) ...<Widget>[
                    const SizedBox(height: 16),
                    _CompletionSection(details: details),
                  ],
                  if (details.attachedMedicalRecords.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 16),
                    _AttachmentSection(
                      title: 'attached_medical_records'.tr(context),
                      attachments: details.attachedMedicalRecords,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.details});

  final AppointmentDetailsModel details;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = switch (details.status) {
      'completed' => AppColors.greenColor,
      'canceled' => AppColors.redColor,
      _ => AppColors.orangeColor,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _Badge(
                label: (details.status ?? 'pending').tr(context),
                color: statusColor,
              ),
              const SizedBox(width: 8),
              _Badge(
                label: _typeLabel(context, details.type),
                color: AppColors.primaryColors,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: _MetaTile(
                  icon: Icons.calendar_month_outlined,
                  label: 'date'.tr(context),
                  value: details.date ?? '--',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetaTile(
                  icon: Icons.access_time_outlined,
                  label: 'time'.tr(context),
                  value: details.time ?? '--:--',
                ),
              ),
            ],
          ),
          if (details.price != null) ...<Widget>[
            const SizedBox(height: 12),
            _MetaTile(
              icon: Icons.payments_outlined,
              label: 'price'.tr(context),
              value: _formatPrice(context, details.price!),
            ),
          ],
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context, String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'lab':
        return 'lab'.tr(context);
      case 'radiology':
        return 'radiology_file'.tr(context);
      default:
        return 'appointment'.tr(context);
    }
  }

  String _formatPrice(BuildContext context, double value) {
    final String formatted = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$formatted ${"sy".tr(context)}';
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.details});

  final AppointmentDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: CustomImageWidget(
              imageUrl: details.doctor?.image,
              placeholderAsset: AssetsData.defaultDoctorProfile,
              height: 68,
              width: 68,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  details.doctor?.fullName ?? '--',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  details.doctor?.specialization ?? '--',
                  style: TextStyle(color: AppColors.grey700Color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.details});

  final AppointmentDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'details'.tr(context),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            title: 'patient_name'.tr(context),
            value: details.patient?.fullName ?? '--',
          ),
          _SummaryRow(
            title: 'gender'.tr(context),
            value: (details.patient?.gender ?? '--').tr(context),
          ),
          if (details.patient?.birthDate != null)
            _SummaryRow(
              title: 'birth_date'.tr(context),
              value: details.patient!.birthDate!,
            ),
        ],
      ),
    );
  }
}

class _TextSectionCard extends StatelessWidget {
  const _TextSectionCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  final String title;
  final IconData icon;
  final String content;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      icon: icon,
      child: Text(
        content,
        style: TextStyle(
          color: AppColors.grey800Color,
          height: 1.6,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  const _DiagnosisCard({required this.diagnosis});

  final AppointmentDiagnosisDetails diagnosis;

  @override
  Widget build(BuildContext context) {
    final int percentage = diagnosis.diagnosisRatio ?? 0;
    return _SectionCard(
      title: 'diagnose'.tr(context),
      icon: Icons.monitor_heart_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            diagnosis.diagnosisName ?? '--',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: LinearProgressIndicator(
                  value: (percentage / 100).clamp(0.0, 1.0),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(999),
                  backgroundColor: AppColors.primaryColors.withValues(
                    alpha: 0.12,
                  ),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColors,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$percentage%',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          if (diagnosis.isEmergency != null) ...<Widget>[
            const SizedBox(height: 10),
            _Badge(
              label: (diagnosis.isEmergency! ? 'emergency' : 'recommended').tr(
                context,
              ),
              color: diagnosis.isEmergency!
                  ? AppColors.redColor
                  : AppColors.greenColor,
            ),
          ],
        ],
      ),
    );
  }
}

class _CompletionSection extends StatelessWidget {
  const _CompletionSection({required this.details});

  final AppointmentDetailsModel details;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (details.hasPharmacy == true)
          _SectionCard(
            title: 'pharmacy_request'.tr(context),
            icon: Icons.local_pharmacy_outlined,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'send_to_center_pharmacy'.tr(context),
                    style: TextStyle(
                      color: AppColors.grey800Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _Badge(
                  label: (details.sendToPharmacy == true ? 'yes' : 'no').tr(
                    context,
                  ),
                  color: details.sendToPharmacy == true
                      ? AppColors.greenColor
                      : AppColors.greyColor,
                ),
              ],
            ),
          ),
        if (details.hasPharmacy == true) const SizedBox(height: 16),
        if (details.prescriptionItems.isNotEmpty) ...<Widget>[
          _SectionCard(
            title: 'prescription_list'.tr(context),
            icon: Icons.medication_outlined,
            child: Column(
              children: List<Widget>.generate(
                details.prescriptionItems.length,
                (int index) {
                  final PrescriptionItem item =
                      details.prescriptionItems[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == details.prescriptionItems.length - 1
                          ? 0
                          : 10,
                    ),
                    child: _ItemCard(
                      title: item.drugName,
                      rows: <MapEntry<String, String>>[
                        MapEntry('dosage'.tr(context), item.dosage),
                        MapEntry(
                          'frequency_per_day'.tr(context),
                          item.frequencyPerDay,
                        ),
                        MapEntry('start_date'.tr(context), item.startDate),
                        MapEntry('end_date'.tr(context), item.endDate),
                        if (item.specialNotes.isNotEmpty)
                          MapEntry(
                            'special_notes'.tr(context),
                            item.specialNotes,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (details.labRequests.isNotEmpty) ...<Widget>[
          _SectionCard(
            title: 'lab_requests'.tr(context),
            icon: Icons.science_outlined,
            child: Column(
              children: List<Widget>.generate(details.labRequests.length, (
                int index,
              ) {
                final AppointmentNamedRequest item = details.labRequests[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == details.labRequests.length - 1 ? 0 : 10,
                  ),
                  child: _ItemCard(
                    title: item.title,
                    rows: <MapEntry<String, String>>[
                      if (item.notes.trim().isNotEmpty)
                        MapEntry('notes'.tr(context), item.notes),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (details.radiologyRequests.isNotEmpty) ...<Widget>[
          _SectionCard(
            title: 'radiology_requests'.tr(context),
            icon: Icons.image_search_outlined,
            child: Column(
              children: List<Widget>.generate(
                details.radiologyRequests.length,
                (int index) {
                  final AppointmentNamedRequest item =
                      details.radiologyRequests[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == details.radiologyRequests.length - 1
                          ? 0
                          : 10,
                    ),
                    child: _ItemCard(
                      title: item.title,
                      rows: <MapEntry<String, String>>[
                        if (item.notes.trim().isNotEmpty)
                          MapEntry('notes'.tr(context), item.notes),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (details.radiologyResult != null)
          _ResultSectionCard(
            title: 'radiology_result'.tr(context),
            result: details.radiologyResult!,
          ),
        if (details.radiologyResult != null && details.labResult != null)
          const SizedBox(height: 16),
        if (details.labResult != null)
          _ResultSectionCard(
            title: 'lab_result'.tr(context),
            result: details.labResult!,
          ),
      ],
    );
  }
}

class _ResultSectionCard extends StatelessWidget {
  const _ResultSectionCard({required this.title, required this.result});

  final String title;
  final AppointmentResultFile result;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      icon: Icons.description_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if ((result.notes ?? '').trim().isNotEmpty)
            Text(
              result.notes!,
              style: TextStyle(color: AppColors.grey800Color, height: 1.5),
            ),
          if (result.hasFile) ...<Widget>[
            if ((result.notes ?? '').trim().isNotEmpty)
              const SizedBox(height: 12),
            if (result.isPdf)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.grey50Color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey200Color),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: AppColors.primaryColors,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'pdf_preview_not_available'.tr(context),
                        style: TextStyle(color: AppColors.grey700Color),
                      ),
                    ),
                  ],
                ),
              )
            else
              InkWell(
                onTap: () =>
                    _openZoomableImageViewer(context, title, result.fileUrl!),
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomImageWidget(
                        imageUrl: result.fileUrl,
                        placeholderAsset: AssetsData.defaultCenter,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Positioned(
                      top: 12,
                      right: 12,
                      child: _ResultExpandBadge(),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _AttachmentSection extends StatelessWidget {
  const _AttachmentSection({required this.title, required this.attachments});

  final String title;
  final List<MedicalRecordAttachment> attachments;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: title,
      icon: Icons.attach_file_outlined,
      child: Column(
        children: List<Widget>.generate(attachments.length, (int index) {
          final MedicalRecordAttachment item = attachments[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == attachments.length - 1 ? 0 : 10,
            ),
            child: _AttachmentCard(attachment: item),
          );
        }),
      ),
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({required this.attachment});

  final MedicalRecordAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final String? attachmentUrl = attachment.url;
    final bool canShow = attachmentUrl != null && attachmentUrl.isNotEmpty;

    return InkWell(
      onTap: canShow ? () => _showAttachmentPreview(context, attachment) : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.grey50Color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200Color),
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: attachment.thumbnailUrl ?? attachment.url,
                placeholderAsset: AssetsData.defaultCenter,
                height: 54,
                width: 54,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    attachment.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if ((attachment.recordDate ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        attachment.recordDate!,
                        style: TextStyle(color: AppColors.grey700Color),
                      ),
                    ),
                  if ((attachment.sourceLabel ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        attachment.sourceLabel!,
                        style: TextStyle(color: AppColors.grey700Color),
                      ),
                    ),
                ],
              ),
            ),
            if (canShow)
              const Icon(
                Icons.open_in_full_rounded,
                color: AppColors.primaryColors,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAttachmentPreview(
    BuildContext context,
    MedicalRecordAttachment attachment,
  ) async {
    final String? url = attachment.url;
    if (url == null || url.isEmpty) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final bool isPdf = url.toLowerCase().endsWith('.pdf');
        return Dialog(
          insetPadding: const EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
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
                if (isPdf)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.grey50Color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grey200Color),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: AppColors.primaryColors,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'pdf_preview_not_available'.tr(context),
                            style: TextStyle(color: AppColors.grey700Color),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: () => _openZoomableImageViewer(
                      context,
                      attachment.title,
                      url,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CustomImageWidget(
                            imageUrl: url,
                            placeholderAsset: AssetsData.defaultCenter,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Positioned(
                          top: 12,
                          right: 12,
                          child: _ResultExpandBadge(),
                        ),
                      ],
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

class _ResultExpandBadge extends StatelessWidget {
  const _ResultExpandBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blackColor.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Icon(
        Icons.open_in_full_rounded,
        size: 16,
        color: AppColors.whiteColor,
      ),
    );
  }
}

Future<void> _openZoomableImageViewer(
  BuildContext context,
  String title,
  String imageUrl,
) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: AppColors.blackColor,
          appBar: AppBar(
            backgroundColor: AppColors.blackColor,
            foregroundColor: AppColors.whiteColor,
            elevation: 0,
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                        imageUrl: imageUrl,
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: AppColors.primaryColors, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.primaryColors,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.title, required this.rows});

  final String title;
  final List<MapEntry<String, String>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.grey50Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          if (rows.isNotEmpty) const SizedBox(height: 10),
          ...rows.map((MapEntry<String, String> row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(color: AppColors.grey800Color, height: 1.5),
                  children: <InlineSpan>[
                    TextSpan(
                      text: '${row.key}: ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: row.value),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.grey700Color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50Color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200Color),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: AppColors.primaryColors),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(color: AppColors.grey700Color, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
