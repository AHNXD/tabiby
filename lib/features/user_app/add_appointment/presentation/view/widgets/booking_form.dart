import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../view-model/booking_cubit.dart';
import '../../view-model/booking_state.dart';
import '../sections/center_section.dart';
import '../sections/datetime_section.dart';
import '../sections/notes_section.dart';

class BookingForm extends StatefulWidget {
  const BookingForm({super.key});

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is AppointmentBookedSuccessfully) {
          messages(context, 'booking_request_sent'.tr(context), Colors.green);
          Navigator.pop(context);
        }
        if (state is BookingFailure) {
          messages(context, state.errMessage, Colors.red);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is BookingLoading) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BookingSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Center Selection
              CenterSection(
                centers: state.centers,
                selectedId: state.selectedCenterId,
                onSelect: (int id) =>
                    context.read<BookingCubit>().selectCenter(id),
              ),
              const SizedBox(height: 24),

              // 2. Date & Time Selection
              if (state.isLoadingDays)
                const Center(child: CircularProgressIndicator())
              else if (state.days.isNotEmpty)
                DateTimeSection(
                  days: state.days,
                  selectedDate: state.selectedDate,
                  onSelectDate: (String day) =>
                      context.read<BookingCubit>().selectDay(day),

                  // Times logic
                  isLoadingTimes: state.isLoadingTimes,
                  periods: state.times?.periods,
                  selectedTimeSlot: state.selectedTime,
                  onSelectTimeSlot: (time, category) {
                    context.read<BookingCubit>().selectTime(time, category);
                  },
                ),

              const SizedBox(height: 24),
              NotesSection(noteController: _noteController),
              const SizedBox(height: 24),

              Center(
                child: state.isBooking
                    ? Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        text: 'book_an_appointment'.tr(context),
                        onPressed: () {
                          if (state.selectedTime != null) {
                            context.read<BookingCubit>().bookAppointment(
                              _noteController.text,
                            );
                          }
                        },
                      ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
