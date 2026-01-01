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
                            isActive: doctor.isActive == 1,
                            imageUrl: doctor.img,
                          ),
                          const SizedBox(height: 24),
                          _buildStatsRow(context, doctor),
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

  Widget _buildStatsRow(BuildContext context, Doctor doctor) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            icon: Icons.star_rounded,
            color: Colors.amber,
            value: (doctor.rate ?? 0).toString(),
            label: "rate".tr(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(
            context,
            icon: Icons.work_history_rounded,
            color: AppColors.primaryColors,
            value: "${doctor.yearsOfExperience ?? 0}+",
            label: "years_of_experience".tr(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
