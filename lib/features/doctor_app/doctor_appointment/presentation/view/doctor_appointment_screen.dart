import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../../user_app/home/presentation/view/widgets/build_appbar.dart';
import '../../../../user_app/user/presentation/view-model/user_cubit/user_cubit.dart';
import '../../data/repos/doctor_appointment_repo.dart';
import '../view_model/doctor_appoinements_cubit.dart';
import 'sections/appointments_info_section.dart';
import 'sections/appointments_list_section.dart';
import 'sections/filters_section.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  static const String routeName = "/doctor_appointment";

  const DoctorAppointmentScreen({super.key});

  @override
  State<DoctorAppointmentScreen> createState() => _DoctorAppointmentViewState();
}

class _DoctorAppointmentViewState extends State<DoctorAppointmentScreen> {
  late String _selectedDateFilter;
  late String _selectedCenterFilter;
  bool _isInitialSetup = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialSetup) {
      _selectedDateFilter = 'today';

      _selectedCenterFilter = 'all';

      _isInitialSetup = false;
    }
  }

  int? _mapCenterToId(String centerValue) {
    if (centerValue == 'all') return null;
    return int.tryParse(centerValue);
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.read<UserCubit>().state;
    List<dynamic> centersList = [];

    if (userState is UserSuccess) {
      centersList = userState.user.mainData?.centers ?? [];
    }
    return BlocProvider(
      create: (context) =>
          DoctorsAppointmentsCubit(getit.get<DoctorAppointmentsRepo>())
            ..getDoctorAppointments(null, null),
      child: Scaffold(
        appBar: BuildAppbar(isDoctor: true),
        body: SafeArea(
          child: Column(
            children: [
              Builder(
                builder: (blocContext) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16,
                  ),
                  child: FiltersSection(
                    centers: centersList,
                    selectedDate: _selectedDateFilter,
                    selectedCenter: _selectedCenterFilter,
                    onDateChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedDateFilter = value);

                        blocContext
                            .read<DoctorsAppointmentsCubit>()
                            .getDoctorAppointments(
                              _mapCenterToId(_selectedCenterFilter),
                              value,
                            );
                      }
                    },
                    onCenterChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCenterFilter = value);

                        blocContext
                            .read<DoctorsAppointmentsCubit>()
                            .getDoctorAppointments(
                              _mapCenterToId(value),
                              _selectedDateFilter,
                            );
                      }
                    },
                  ),
                ),
              ),

              Expanded(
                child:
                    BlocBuilder<
                      DoctorsAppointmentsCubit,
                      DoctorsAppointmentsState
                    >(
                      builder: (context, state) {
                        if (state is DoctorsAppointmentSuccess) {
                          final appointments =
                              state.doctorsAppointment.appointments;
                          Future<void> onRefresh() async {
                            await context
                                .read<DoctorsAppointmentsCubit>()
                                .getDoctorAppointments(
                                  _mapCenterToId(_selectedCenterFilter),
                                  _selectedDateFilter,
                                );
                          }

                          return RefreshIndicator(
                            onRefresh: onRefresh,
                            child: ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              children: [
                                AppointmentsInfoSection(
                                  appointmentCount: appointments.length,
                                  selectedDate: _selectedDateFilter,
                                ),
                                const SizedBox(height: 16),
                                AppointmentsListSection(
                                  appointments: appointments,
                                  onRefresh: onRefresh,
                                ),
                              ],
                            ),
                          );
                        } else if (state is DoctorsAppointmentError) {
                          return CustomErrorWidget(
                            textColor: Colors.black,
                            errorMessage: state.errorMsg,
                            onRetry: () {
                              context
                                  .read<DoctorsAppointmentsCubit>()
                                  .getDoctorAppointments(
                                    _mapCenterToId(_selectedCenterFilter),
                                    _selectedDateFilter,
                                  );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
