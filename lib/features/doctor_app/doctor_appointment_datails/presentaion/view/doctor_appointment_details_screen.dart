import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/utils/constats.dart';
import 'package:tabiby/core/utils/functions.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../doctor_appointment/presentation/view_model/doctor_appoinements_cubit.dart';
import '../../data/repos/doctor_appointment_details_repo.dart';
import '../view_model/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import '../view_model/cancel_appointment_cubit/cancel_appointment_state.dart';
import '../view_model/doctor_appointment_details_cubit/doctor_appoinement_details_cubit.dart';
import '../view_model/end_appointment_cubit/end_appointment_cubit.dart';
import 'end_appointment_screen.dart';
import 'sections/bottom_buttons_section.dart';
import 'sections/patient_info_section.dart';
import 'sections/scheduled_time_section.dart';
import 'widgets/appointment_details_header.dart';
import '../../data/models/doctor_appointment_details_model.dart';

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  static const String routeName = "/doctor_appointment_details";
  final int id;
  final String status;
  const DoctorAppointmentDetailsScreen({
    super.key,
    required this.id,
    required this.status,
  });

  @override
  State<DoctorAppointmentDetailsScreen> createState() =>
      _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState
    extends State<DoctorAppointmentDetailsScreen> {
  bool _didDisableScreenshots = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || isSecureMode) {
        return;
      }

      await disableScreenshot();
      _didDisableScreenshots = true;
    });
  }

  @override
  void dispose() {
    if (_didDisableScreenshots) {
      enableScreenshot();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DoctorsAppointmentDetailsCubit(
            getit.get<DoctorAppointmentDetailsRepo>(),
          )..getDoctorAppointmentDetails(widget.id),
        ),
        BlocProvider(
          create: (context) =>
              CancelAppointmentCubit(getit.get<DoctorAppointmentDetailsRepo>()),
        ),
        BlocProvider(
          create: (context) =>
              EndAppointmentCubit(getit.get<DoctorAppointmentDetailsRepo>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<CancelAppointmentCubit, CancelAppointmentState>(
                listener: (context, state) {
                  if (state is CancelAppointmentSuccess) {
                    messages(context, state.message, AppColors.greenColor);
                    try {
                      context
                          .read<DoctorsAppointmentsCubit>()
                          .getDoctorAppointments(null, null);
                    } catch (e) {
                      debugPrint(
                        "Could not refresh list directly: Cubit not found in this context.",
                      );
                    }
                    Navigator.of(context).pop(true);
                  } else if (state is CancelAppointmentFailure) {
                    messages(context, state.error, AppColors.redColor);
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: AppColors.grey100Color,
              appBar: CustomAppbar(title: "appointment_details".tr(context)),
              body:
                  BlocBuilder<
                    DoctorsAppointmentDetailsCubit,
                    DoctorsAppointmentDetailsState
                  >(
                    builder: (context, state) {
                      if (state is DoctorAppointmentDetailsSuccess) {
                        final details = state.doctorsAppointmentDetails;

                        return SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppointmentDetailsHeader(
                                  appointment: details,
                                  primaryColor: details.status == "completed"
                                      ? AppColors.greenColor
                                      : details.status == "pending"
                                      ? AppColors.orangeColor
                                      : AppColors.redColor,
                                ),
                                const SizedBox(height: 16),

                                // Patient Note Section
                                if (details.note != null &&
                                    details.note!.isNotEmpty) ...[
                                  _buildPatientNoteButton(
                                    context,
                                    details.note!,
                                  ),
                                  const SizedBox(height: 24),
                                ],

                                // Diagnosis Section (Updated Logic)
                                if (details.diagnose != null) ...[
                                  _buildDiagnosisCard(
                                    context,
                                    details.diagnose!,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                PatientInfoSection(appointmentDetails: details),

                                const SizedBox(height: 24),
                                ScheduledTimeSection(appointment: details),
                                if (_hasCompletionSummary(details)) ...[
                                  const SizedBox(height: 24),
                                  _buildCompletionSummary(context, details),
                                ],
                              ],
                            ),
                          ),
                        );
                      } else if (state is DoctorsAppointmentDetailsError) {
                        return CustomErrorWidget(
                          textColor: AppColors.blackColor,
                          errorMessage: state.errorMsg,
                          onRetry: () {
                            context
                                .read<DoctorsAppointmentDetailsCubit>()
                                .getDoctorAppointmentDetails(widget.id);
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
              bottomNavigationBar:
                  BlocBuilder<
                    DoctorsAppointmentDetailsCubit,
                    DoctorsAppointmentDetailsState
                  >(
                    builder: (context, state) {
                      if (state is! DoctorAppointmentDetailsSuccess) {
                        return const SizedBox.shrink();
                      }

                      final DoctorAppointmentDetailsModel details =
                          state.doctorsAppointmentDetails;

                      if (details.status != 'pending') {
                        return const SizedBox.shrink();
                      }

                      return BottomButtonsSection(
                        onCancel: () {
                          context
                              .read<CancelAppointmentCubit>()
                              .cancelAppointment(widget.id);
                        },
                        onEndAppointment: () =>
                            _showEndAppointmentDialog(context, details),
                      );
                    },
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiagnosisCard(BuildContext context, Diagnose diagnosis) {
    final bool isEmergency = diagnosis.isEmergency ?? false;
    final int rawRatio = diagnosis.ratio ?? 0;

    final int percentageText = rawRatio.toInt();

    final double progressBarValue = (rawRatio / 100.0).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEmergency
              ? AppColors.redColor.withValues(alpha: 0.5)
              : AppColors.primaryColors.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isEmergency
                ? AppColors.redColor.withValues(alpha: 0.05)
                : AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.monitor_heart_outlined,
                  color: AppColors.primaryColors,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "diagnose".tr(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const Spacer(),
              if (isEmergency)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.red50Color,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.red100Color),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: AppColors.redColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "emergency".tr(context),
                        style: const TextStyle(
                          color: AppColors.redColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1),
          ),

          Text(
            diagnosis.name ?? "unknown_diagnosis",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColors,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Confidence/Ratio Bar
          if (diagnosis.ratio != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "confidence".tr(context),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey600Color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "$percentageText%",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColors,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressBarValue,
                minHeight: 8,
                backgroundColor: AppColors.primaryColors.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentageText > 80
                      ? AppColors.primaryColors
                      : AppColors.primaryColors.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _hasCompletionSummary(DoctorAppointmentDetailsModel details) {
    return (details.doctorNote ?? '').trim().isNotEmpty ||
        details.prescriptionItems.isNotEmpty ||
        details.labRequests.isNotEmpty ||
        details.radiologyRequests.isNotEmpty ||
        details.hasPharmacy == true;
  }

  Widget _buildCompletionSummary(
    BuildContext context,
    DoctorAppointmentDetailsModel details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'appointment_completion_details'.tr(context),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.primaryColors,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if ((details.doctorNote ?? '').trim().isNotEmpty) ...<Widget>[
          _buildInfoCard(
            context,
            title: 'doctor_notes'.tr(context),
            icon: Icons.sticky_note_2_outlined,
            child: Text(
              details.doctorNote!,
              style: TextStyle(
                color: AppColors.grey800Color,
                height: 1.6,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (details.hasPharmacy == true) ...<Widget>[
          _buildInfoCard(
            context,
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
                _buildStatusBadge(
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
          const SizedBox(height: 12),
        ],
        if (details.prescriptionItems.isNotEmpty) ...<Widget>[
          _buildInfoCard(
            context,
            title: 'prescription_list'.tr(context),
            icon: Icons.medication_outlined,
            child: Column(
              children: List<Widget>.generate(details.prescriptionItems.length, (
                int index,
              ) {
                final PrescriptionItemDetails item =
                    details.prescriptionItems[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == details.prescriptionItems.length - 1
                        ? 0
                        : 12,
                  ),
                  child: _buildReadOnlyItemCard(
                    context,
                    title:
                        '${'medication'.tr(context)} ${index + 1}: ${item.medicineName}',
                    rows: <MapEntry<String, String>>[
                      MapEntry('dose'.tr(context), item.dose),
                      MapEntry('frequency_per_day'.tr(context), item.frequency),
                      MapEntry('start_date'.tr(context), item.startDate),
                      MapEntry('end_date'.tr(context), item.endDate),
                      if (item.instructions.trim().isNotEmpty)
                        MapEntry(
                          'special_notes'.tr(context),
                          item.instructions,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (details.labRequests.isNotEmpty) ...<Widget>[
          _buildInfoCard(
            context,
            title: 'lab_tests'.tr(context),
            icon: Icons.science_outlined,
            child: Column(
              children: List<Widget>.generate(details.labRequests.length, (
                int index,
              ) {
                final LabRequestDetails item = details.labRequests[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == details.labRequests.length - 1 ? 0 : 10,
                  ),
                  child: _buildReadOnlyItemCard(
                    context,
                    title: item.name,
                    rows: <MapEntry<String, String>>[
                      if (item.notes.trim().isNotEmpty)
                        MapEntry('notes'.tr(context), item.notes),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (details.radiologyRequests.isNotEmpty)
          _buildInfoCard(
            context,
            title: 'radiology_requests'.tr(context),
            icon: Icons.image_search_outlined,
            child: Column(
              children: List<Widget>.generate(
                details.radiologyRequests.length,
                (int index) {
                  final RadiologyRequestDetails item =
                      details.radiologyRequests[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == details.radiologyRequests.length - 1
                          ? 0
                          : 10,
                    ),
                    child: _buildReadOnlyItemCard(
                      context,
                      title: item.typeName,
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
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryColors, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

  Widget _buildReadOnlyItemCard(
    BuildContext context, {
    required String title,
    required List<MapEntry<String, String>> rows,
  }) {
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

  Widget _buildStatusBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.22)),
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

  void _showEndAppointmentDialog(
    BuildContext context,
    DoctorAppointmentDetailsModel appointment,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (routeContext) => BlocProvider.value(
          value: BlocProvider.of<EndAppointmentCubit>(context),
          child: EndAppointmentScreen(appointment: appointment),
        ),
      ),
    );

    if (result == true && context.mounted) {
      try {
        context.read<DoctorsAppointmentsCubit>().getDoctorAppointments(
          null,
          null,
        );
      } catch (e) {
        debugPrint(
          "Warning: DoctorsAppointmentsCubit not found in context. List might not refresh.",
        );
      }

      Navigator.of(context).pop();
    }
  }

  Widget _buildPatientNoteButton(BuildContext context, String note) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () => _showNoteDialog(context, note),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.note_alt_rounded,
            color: AppColors.primaryColors,
            size: 24,
          ),
        ),
        title: Text(
          "patient_note".tr(context),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.greyColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.greyColor,
          ),
        ),
      ),
    );
  }

  // --- Helper to Show Dialog (Styled) ---
  void _showNoteDialog(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        // 1. Transparent background
        backgroundColor: AppColors.transparentColor,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 2. Title
              Text(
                "patient_note".tr(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColors,
                ),
              ),
              const SizedBox(height: 24),

              // 3. Styled Content Container
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.grey50Color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grey200Color),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Small Icon Badge
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColors.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.format_quote_rounded,
                                color: AppColors.primaryColors,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // The actual text
                            Expanded(
                              child: Text(
                                note,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: AppColors.grey800Color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 4. Full Width Button
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
                      color: AppColors.whiteColor,
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
}
