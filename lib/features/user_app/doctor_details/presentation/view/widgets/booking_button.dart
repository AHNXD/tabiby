import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:tabiby/core/widgets/primary_button.dart';

import '../../../../add_appointment/presentation/view/booking_screen.dart';

class BookingButton extends StatelessWidget {
  const BookingButton({super.key, required this.doctorID, this.doctorType});
  final int doctorID;
  final String? doctorType;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColors.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: PrimaryButton(
        text: 'book_an_appointment'.tr(context),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookingScreen(doctorID: doctorID, doctorType: doctorType),
            ),
          );
        },
      ),
    );
  }
}
