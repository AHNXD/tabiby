import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../sections/center_section.dart';
import '../sections/datetime_section.dart';
import '../sections/notes_section.dart';
import 'data.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  int _selectedCenterIndex = 0;
  int _selectedDateIndex = 0;
  String? _selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CenterSection(
          centers: centers,
          selectedIndex: _selectedCenterIndex,
          onSelect: (index) => setState(() => _selectedCenterIndex = index),
        ),
        const SizedBox(height: 24),
        DateTimeSection(
          dates: dates,
          selectedDateIndex: _selectedDateIndex,
          onSelectDate: (index) => setState(() => _selectedDateIndex = index),
          timeSlots: timeSlots,
          selectedTimeSlot: _selectedTimeSlot,
          onSelectTimeSlot: (slot) => setState(() => _selectedTimeSlot = slot),
        ),
        const SizedBox(height: 24),
        const NotesSection(),
        const SizedBox(height: 24),
        Center(
          child: PrimaryButton(
            text: 'book_an_appointment'.tr(context),
            onPressed: () {
              messages(
                context,
                'booking_request_sent'.tr(context),
                Colors.green,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
