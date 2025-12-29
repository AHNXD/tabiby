import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../../core/widgets/custom_snackbar.dart';
import '../../data/repos/doctor_appointment_details_repo.dart';
import '../view_model/cancel_appointment_cubit/cancel_appointment_cubit.dart';
import '../view_model/cancel_appointment_cubit/cancel_appointment_state.dart';
import '../view_model/doctor_appointment_details_cubit/doctor_appoinement_details_cubit.dart';
import '../view_model/end_appointment_cubit/end_appointment_cubit.dart';
import '../view_model/end_appointment_cubit/end_appointment_state.dart';
import 'sections/bottom_buttons_section.dart';
import 'sections/patient_info_section.dart';
import 'sections/scheduled_time_section.dart';
import 'widgets/appointment_details_header.dart';
import 'widgets/end_appointment_dialog.dart';

class DoctorAppointmentDetailsScreen extends StatelessWidget {
  static const String routeName = "/doctor_appointment_details";
  final int id;

  const DoctorAppointmentDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DoctorsAppointmentDetailsCubit(
                getit.get<DoctorAppointmentDetailsRepo>(),
              )..getDoctorAppointmentDetails(id),
        ),
        BlocProvider(
          create: (context) =>
              CancelAppointmentCubit(
                getit.get<DoctorAppointmentDetailsRepo>(),
              ),
        ),
        BlocProvider(
          create: (context) =>
              EndAppointmentCubit(
                getit.get<DoctorAppointmentDetailsRepo>(),
              ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CancelAppointmentCubit, CancelAppointmentState>(
            listener: (context, state) {
              if (state is CancelAppointmentSuccess) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                );
                Navigator.of(context).pop();
              } else if (state is CancelAppointmentFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
          BlocListener<EndAppointmentCubit, EndAppointmentState>(
            listener: (context, state) {
              if (state is EndAppointmentSuccess) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                );
                Navigator.of(context).pop();
              } else if (state is EndAppointmentFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: CustomAppbar(
            title: "appointment_details".tr(context),
          ),
          body: BlocBuilder<DoctorsAppointmentDetailsCubit,
              DoctorsAppointmentDetailsState>(
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
                          primaryColor: AppColors.primaryColors,
                        ),
                        const SizedBox(height: 24),
                        PatientInfoSection(
                          appointmentDetails:
                              state.doctorsAppointmentDetails,
                        ),
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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          bottomNavigationBar: BottomButtonsSection(
            onCancel: () {
              context
                  .read<CancelAppointmentCubit>()
                  .cancelAppointment(id);
            },
            onEndAppointment: () => _showEndAppointmentDialog(context),
          ),
        ),
      ),
    );
  }

  void _showEndAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => EndAppointmentDialog(
        primaryColor: AppColors.primaryColors,
        appointmentId: id,
      ),
    );
  }
}
