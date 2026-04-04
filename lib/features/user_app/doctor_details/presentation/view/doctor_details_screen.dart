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
      backgroundColor: AppColors.appBackgroundColor,
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
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                      children: [
                        DoctorHeader(
                          name: doctor.name ?? '',
                          specialty: doctor.specialty?.name ?? '',
                          isActive: doctor.isActive == 1,
                          imageUrl: doctor.img,
                          centerCount: doctor.centers?.length ?? 0,
                        ),
                        const SizedBox(height: 18),
                        _DoctorHighlightsRow(doctor: doctor),
                        const SizedBox(height: 20),
                        BiographySection(biography: doctor.bio ?? ""),
                        const SizedBox(height: 20),
                        AffiliatedCentersSection(centers: doctor.centers ?? []),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                      child: BookingButton(
                        doctorID: doctorID,
                        doctorType: doctor.doctorType,
                      ),
                    ),
                  ),
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
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColors,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class _DoctorHighlightsRow extends StatelessWidget {
  const _DoctorHighlightsRow({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DoctorStatCard(
            icon: Icons.star_rounded,
            color: Colors.amber,
            value: (doctor.rate ?? 0).toString(),
            label: "rate".tr(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _DoctorStatCard(
            icon: Icons.work_history_rounded,
            color: AppColors.primaryColors,
            value: "${doctor.yearsOfExperience ?? 0}+",
            label: "years_of_experience".tr(context),
          ),
        ),
      ],
    );
  }
}

class _DoctorStatCard extends StatelessWidget {
  const _DoctorStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) : _icon = icon,
       _color = color,
       _value = value,
       _label = label;

  final IconData _icon;
  final Color _color;
  final String _value;
  final String _label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: _color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            _value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2C28),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
