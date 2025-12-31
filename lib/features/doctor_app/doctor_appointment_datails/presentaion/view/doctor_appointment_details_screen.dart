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
                                PatientInfoSection(
                                  appointmentDetails:
                                      state.doctorsAppointmentDetails,
                                ),
                                const SizedBox(height: 24),

                                const SizedBox(height: 40),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showNoteDialog(context, note),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColors.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.note_alt_outlined, color: AppColors.primaryColors),
        ),
        title: Text(
          "patient_note".tr(context),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  // --- Helper to Show Dialog ---
  void _showNoteDialog(BuildContext context, String note) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.notes, color: AppColors.primaryColors),
                  const SizedBox(width: 10),
                  Text(
                    "patient_note".tr(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColors,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    note,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("close".tr(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
