import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/widgets/primary_button.dart';

import '../../../../add_appointment/presentation/view/booking_screen.dart';

class BookingButton extends StatelessWidget {
  const BookingButton({super.key, required this.doctorID});
  final int doctorID;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
      child: PrimaryButton(
        text: 'book_an_appointment'.tr(context),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(doctorID: doctorID),
            ),
          );
        },
      ),
    );
  }
}
