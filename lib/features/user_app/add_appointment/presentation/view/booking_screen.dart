import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';

import '../../../../../core/utils/services_locater.dart';
import '../../../../../core/widgets/custom_appbar.dart';
import '../../data/repos/add_appoinment_repo.dart';
import '../view-model/booking_cubit.dart';
import 'widgets/booking_form.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = "/add_appointment";
  const BookingScreen({super.key, required this.doctorID});
  final int doctorID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppbar(title: "book_appointment".tr(context)),
      ),
      body: BlocProvider(
        create: (context) =>
            BookingCubit(getit.get<AddAppoinmentRepo>(), doctorID)
              ..fetchCenters(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: const BookingForm(),
        ),
      ),
    );
  }
}
