import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/medical_files/data/repos/medical_files_repo.dart';

import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../data/repos/add_appoinment_repo.dart';
import '../view-model/booking_cubit.dart';
import 'widgets/booking_form.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = "/add_appointment";
  const BookingScreen({
    super.key,
    required this.doctorID,
    this.doctorType,
    this.availableLabTests,
  });
  final int doctorID;
  final String? doctorType;
  final List<LabTestOption>? availableLabTests;

  @override
  Widget build(BuildContext context) {
    final BookingDepartmentType departmentType =
        BookingDepartmentTypeX.fromDoctorType(doctorType);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppbar(title: "book_appointment".tr(context)),
      ),
      body: BlocProvider(
        create: (context) => BookingCubit(
          getit.get<AddAppoinmentRepo>(),
          getit.get<MedicalFilesRepo>(),
          doctorID,
          departmentType: departmentType,
        )..fetchCenters(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.primaryColors.withValues(alpha: 0.12),
                AppColors.appBackgroundColor,
                Colors.white,
              ],
              stops: const <double>[0, 0.28, 1],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            child: const BookingForm(),
          ),
        ),
      ),
    );
  }
}
