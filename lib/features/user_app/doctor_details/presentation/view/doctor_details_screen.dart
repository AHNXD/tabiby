import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/features/user_app/doctor_details/data/models/doctor_model.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../../../../core/widgets/custom_error_widget.dart';
import '../../../doctors/data/repos/doctors_repo.dart';
import '../view_model/doctor_details_cubit.dart';
import 'sections/affiliated_centers_section.dart';
import 'sections/biography_section.dart';
import 'widgets/booking_button.dart';
import 'widgets/doctor_header.dart';

class DoctorDetailsScreen extends StatelessWidget {
  static const String routeName = "/doctor_details";
  final int doctorID;

  const DoctorDetailsScreen({super.key, required this.doctorID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "doctor_details".tr(context)),
      body: BlocProvider(
        create: (context) =>
            DoctorDetailsCubit(getit.get<DoctorsRepo>())..getDoctor(doctorID),

        child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          builder: (context, state) {
            if (state is DoctorDetailsSuccess) {
              Doctor doctor = state.doctor;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          DoctorHeader(
                            name: doctor.name ?? '',
                            specialty: doctor.specialty?.name ?? '',
                            experience:
                                '${doctor.yearsOfExperience ?? 0} ${"years_of_experience".tr(context)}',
                            imageUrl: doctor.img,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 22,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (doctor.rate ?? 0).toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColor,
                                ),
                              ),
                            ],
                          ),
                          // Rating Section
                          const SizedBox(height: 24),
                          // Biography Section
                          BiographySection(biography: doctor.bio ?? ""),
                          const SizedBox(height: 24),
                          // Affiliated Centers Section
                          AffiliatedCentersSection(
                            centers: doctor.centers ?? [],
                          ),
                        ],
                      ),
                    ),
                  ),
                  BookingButton(doctorID: doctorID),
                ],
              );
            } else if (state is DoctorDetailsError) {
              return CustomErrorWidget(
                textColor: Colors.black,
                errorMessage: state.errorMsg,
                onRetry: () {
                  context.read<DoctorDetailsCubit>().getDoctor(doctorID);
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
