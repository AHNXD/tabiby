import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../../../diagnose/presentation/view_models/diagnosis_cubit.dart';
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
    final diagnosisState = context.read<DiagnosisCubit>().state;
    final hasDiagnosis = diagnosisState.diagnosisResult != null;
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is AppointmentBookedSuccessfully) {
          messages(context, 'booking_request_sent'.tr(context), Colors.green);
          Navigator.pop(context);
        }
        if (state is BookingFailure) {
          messages(context, state.errMessage, Colors.red);
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
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),
              if (hasDiagnosis) ...[
                _buildDiagnosisSection(context, state, diagnosisState),
                const SizedBox(height: 16),
              ],

              NotesSection(noteController: _noteController),
              const SizedBox(height: 16),

              Center(
                child: state.isBooking
                    ? Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        text: 'book_an_appointment'.tr(context),
                        onPressed: () {
                          if (state.selectedTime != null) {
                            // Prepare data
                            String? diagName;
                            String? diagRatio;

                            // Only send if checkbox is checked
                            if (state.includeDiagnosis && hasDiagnosis) {
                              // Adjust these field names based on your DiagnosisResult model
                              diagName =
                                  diagnosisState.diagnosisResult!.result!.name;
                              diagRatio = diagnosisState
                                  .diagnosisResult!
                                  .result!
                                  .confidence
                                  .toString();
                            }

                            context.read<BookingCubit>().bookAppointment(
                              _noteController.text,
                              diagnosisName: diagName,
                              diagnosisRatio: diagRatio,
                              isEmergency:
                                  state.isEmergency, // Send emergency flag
                            );
                          } else {
                            messages(
                              context,
                              "please_select_time".tr(context),
                              Colors.orange,
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

  Widget _buildDiagnosisSection(
    BuildContext context,
    BookingSuccess bookingState,
    DiagnosisState diagnosisState,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. Toggle to Include
          Row(
            children: [
              Checkbox(
                value: bookingState.includeDiagnosis,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (val) {
                  context.read<BookingCubit>().toggleIncludeDiagnosis(
                    val ?? false,
                  );
                },
              ),
              Expanded(
                child: Text(
                  "attach_diagnosis_result".tr(context), // Add to lang
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          // B. Show Details & Emergency ONLY if included
          if (bookingState.includeDiagnosis) ...[
            const Divider(),
            const SizedBox(height: 8),

            // Diagnosis Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "diagnosis_result".tr(context),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // Adjust field names to match your model
                    diagnosisState.diagnosisResult?.result?.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColors,
                    ),
                  ),
                  Text(
                    "${"confidence".tr(context)}: ${diagnosisState.diagnosisResult?.result?.confidence ?? ''}%",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
