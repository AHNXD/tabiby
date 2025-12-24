import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/services_locater.dart';
import 'package:tabiby/core/widgets/custom_appbar.dart';
import 'package:tabiby/core/widgets/custom_error_widget.dart';
import 'package:tabiby/features/user_app/user_appointments/data/repos/my_appointments_repo.dart';
import 'package:tabiby/features/user_app/user_appointments/presentation/view-model/my_appointments_cubit.dart';
import '../../../../../core/utils/app_localizations.dart';
import 'widgets/colored_text_bar.dart';
import 'widgets/appointment_list.dart';

class UserAppointmentScreen extends StatelessWidget {
  static const String routeName = "/user_appointments";
  const UserAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(
          title: 'my_appointments'.tr(context),
          showBackButton: false,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(
          lazy: false,
          create: (context) =>
              MyAppointmentsCubit(getit.get<MyAppointmentsRepo>())
                ..getMyAppointments(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SafeArea(
              child: BlocBuilder<MyAppointmentsCubit, MyAppointmentsState>(
                builder: (context, state) {
                  if (state is MyAppointmentsSuccess) {
                    return Column(
                      children: [
                        const ColoredTextTabBar(),
                        const SizedBox(height: 16),

                        Expanded(
                          child: TabBarView(
                            children: [
                              AppointmentList(
                                appointments:
                                    state.myAppointments.finished ?? [],
                              ),
                              AppointmentList(
                                appointments:
                                    state.myAppointments.pending ?? [],
                              ),
                              AppointmentList(
                                appointments:
                                    state.myAppointments.canceled ?? [],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is MyAppointmentsError) {
                    return Center(
                      child: CustomErrorWidget(
                        textColor: Colors.black,
                        errorMessage: state.errorMsg,
                        onRetry: () => context
                            .read<MyAppointmentsCubit>()
                            .getMyAppointments(),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
