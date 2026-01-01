import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
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
import 'sections/bottom_buttons_section.dart';
import 'sections/patient_info_section.dart';
import 'sections/scheduled_time_section.dart';
import 'widgets/appointment_details_header.dart';
import 'widgets/end_appointment_dialog.dart';

class DoctorAppointmentDetailsScreen extends StatelessWidget {
  static const String routeName = "/doctor_appointment_details";
  final int id;
  final String status;
  const DoctorAppointmentDetailsScreen({
    super.key,
    required this.id,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DoctorsAppointmentDetailsCubit(
            getit.get<DoctorAppointmentDetailsRepo>(),
          )..getDoctorAppointmentDetails(id),
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
                    messages(context, state.message, Colors.green);
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
                    messages(context, state.error, Colors.red);
                  }
                },
              ),
            ],
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: CustomAppbar(title: "appointment_details".tr(context)),
              body:
                  BlocBuilder<
                    DoctorsAppointmentDetailsCubit,
                    DoctorsAppointmentDetailsState
                  >(
                    builder: (context, state) {
                      if (state is DoctorAppointmentDetailsSuccess) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppointmentDetailsHeader(
                                  appointment: state.doctorsAppointmentDetails,
                                  primaryColor:
                                      state.doctorsAppointmentDetails.status ==
                                          "completed"
                                      ? Colors.green
                                      : state
                                                .doctorsAppointmentDetails
                                                .status ==
                                            "pending"
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                                const SizedBox(height: 16),
                                if (state.doctorsAppointmentDetails.note !=
                                        null &&
                                    state
                                        .doctorsAppointmentDetails
                                        .note!
                                        .isNotEmpty) ...[
                                  _buildPatientNoteButton(
                                    context,
                                    state.doctorsAppointmentDetails.note!,
                                  ),
                                ],
                                const SizedBox(height: 16),
                                if (state.doctorsAppointmentDetails.diagnose !=
                                        null &&
                                    state
                                        .doctorsAppointmentDetails
                                        .diagnose!
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 24),
                                  _buildDiagnosisCard(
                                    context,
                                    state.doctorsAppointmentDetails.diagnose!,
                                  ),
                                ],
                                const SizedBox(height: 16),
                                PatientInfoSection(
                                  appointmentDetails:
                                      state.doctorsAppointmentDetails,
                                ),

                                const SizedBox(height: 24),
                                ScheduledTimeSection(
                                  appointment: state.doctorsAppointmentDetails,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is DoctorsAppointmentDetailsError) {
                        return CustomErrorWidget(
                          textColor: Colors.black,
                          errorMessage: state.errorMsg,
                          onRetry: () {
                            context
                                .read<DoctorsAppointmentDetailsCubit>()
                                .getDoctorAppointmentDetails(id);
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
              bottomNavigationBar: status == 'pending'
                  ? BottomButtonsSection(
                      onCancel: () {
                        context
                            .read<CancelAppointmentCubit>()
                            .cancelAppointment(id);
                      },
                      onEndAppointment: () =>
                          _showEndAppointmentDialog(context),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDiagnosisCard(BuildContext context, String diagnosis) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColors.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(
                Icons.medical_services_outlined,
                color: AppColors.primaryColors,
              ),
              const SizedBox(width: 8),
              Text(
                "diagnosis".tr(
                  context,
                ), // Ensure this key exists in your lang file
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColors,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            diagnosis,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showEndAppointmentDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: BlocProvider.of<EndAppointmentCubit>(context),
        child: EndAppointmentDialog(
          primaryColor: AppColors.primaryColors,
          appointmentId: id,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          16,
        ), // Increased slightly to match theme
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            color: AppColors.primaryColors.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.note_alt_rounded, // Switched to rounded for consistency
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
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
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
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
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
                                color: AppColors.primaryColors.withOpacity(0.1),
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
                                  color: Colors.grey.shade800,
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
}
