import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';
import 'widgets/booking_form.dart';

class BookingScreen extends StatelessWidget {
  static const String routeName = "/add_appointment";
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppbar(title: "Book Appointment"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: BookingForm(),
      ),
    );
  }
}
