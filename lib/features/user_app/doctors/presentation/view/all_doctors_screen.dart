import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctor_details/data/models/doctor_model.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../data/repos/doctors_repo.dart';
import '../view_model/doctor_cubit.dart';
import 'widgets/doctor_card.dart';

class AllDoctorsScreen extends StatelessWidget {
  static const String routeName = "/doctors";

  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? arguments = ModalRoute.of(context)!.settings.arguments;

    final Map<String, dynamic> args =
        (arguments != null && arguments is Map<String, dynamic>)
        ? arguments
        : {};
    final int? centerID = args['centerID'];
    final int? specialtyID = args['specialtyID'];
    return Scaffold(
      appBar: CustomAppbar(title: "all_popular_doctors".tr(context)),
      body: BlocProvider(
        create: (BuildContext context) {
          return DoctorsCubit(getit.get<DoctorsRepo>())
            ..getDoctors(centerID, specialtyID);
        },
        child: BlocBuilder<DoctorsCubit, DoctorsState>(
          builder: (context, state) {
            if (state is DoctorsSuccess) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: state.doctors.doctors?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoctorCard(
                        doctor: state.doctors.doctors?[index] ?? Doctor(),
                      ),
                    );
                  },
                ),
              );
            } else if (state is DoctorsError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<DoctorsCubit>().getDoctors(
                    centerID,
                    specialtyID,
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
