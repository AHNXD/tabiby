import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';
import '../../../../../../core/utils/colors.dart';
import '../../../../../../core/widgets/primary_button.dart';
import '../../../../diagnose/presentation/view_models/diagnosis_cubit.dart';
import '../medical_attachment_picker_screen.dart';
import '../sections/appointment_details_section.dart';
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

        final BookingSuccess? bookingState = state is BookingSuccess
            ? state
            : state is BookingFailure
            ? state.previousState
            : null;

        if (bookingState != null) {
          return _buildBookingContent(
            context,
            bookingState,
            diagnosisState,
            hasDiagnosis,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBookingContent(
    BuildContext context,
    BookingSuccess state,
    DiagnosisState diagnosisState,
    bool hasDiagnosis,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CenterSection(
          centers: state.centers,
          selectedId: state.selectedCenterId,
          onSelect: (int id) => context.read<BookingCubit>().selectCenter(id),
        ),
        const SizedBox(height: 16),
        if (state.isLoadingDays)
          const Center(child: CircularProgressIndicator())
        else if (state.days.isNotEmpty)
          DateTimeSection(
            days: state.days,
            selectedDate: state.selectedDate,
            onSelectDate: (String day) =>
                context.read<BookingCubit>().selectDay(day),
            isLoadingTimes: state.isLoadingTimes,
            periods: state.times?.periods,
            selectedTimeSlot: state.selectedTime,
            onSelectTimeSlot: (time, category) {
              context.read<BookingCubit>().selectTime(time, category);
            },
          ),
        const SizedBox(height: 16),
        AppointmentDetailsSection(
          departmentType: state.departmentType,
          availableLabTests: state.availableLabTests,
          selectedLabTestIds: state.selectedLabTestIds,
          imageType: state.imageType,
          onImageTypeChanged: context.read<BookingCubit>().updateImageType,
          onToggleLabTest: context.read<BookingCubit>().toggleLabTestSelection,
          selectedXrayAttachment: state.selectedXrayAttachment,
          selectedLabResultAttachment: state.selectedLabResultAttachment,
          availableXrayCount: state.availableXrayAttachments.length,
          availableLabResultCount: state.availableLabResultAttachments.length,
          onPickXray: () => _openAttachmentPicker(
            context,
            title: 'xray_records'.tr(context),
            type: MedicalAttachmentType.xray,
            attachments: state.availableXrayAttachments,
            selectedAttachmentId: state.selectedXrayAttachment?.id,
            onSelected: context.read<BookingCubit>().selectAttachedXray,
          ),
          onPickLabResult: () => _openAttachmentPicker(
            context,
            title: 'lab_results'.tr(context),
            type: MedicalAttachmentType.labResult,
            attachments: state.availableLabResultAttachments,
            selectedAttachmentId: state.selectedLabResultAttachment?.id,
            onSelected: context.read<BookingCubit>().selectAttachedLabResult,
          ),
          onClearXray: () =>
              context.read<BookingCubit>().selectAttachedXray(null),
          onClearLabResult: () =>
              context.read<BookingCubit>().selectAttachedLabResult(null),
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
              ? const CircularProgressIndicator()
              : PrimaryButton(
                  text: 'book_an_appointment'.tr(context),
                  onPressed: () => _submitBooking(
                    context,
                    state,
                    diagnosisState,
                    hasDiagnosis,
                  ),
                ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _submitBooking(
    BuildContext context,
    BookingSuccess state,
    DiagnosisState diagnosisState,
    bool hasDiagnosis,
  ) {
    if (state.selectedTime == null) {
      messages(context, "please_select_time".tr(context), Colors.orange);
      return;
    }

    final String? detailsValidationMessage = _validateBookingDetails(
      context,
      state,
    );
    if (detailsValidationMessage != null) {
      messages(context, detailsValidationMessage, Colors.orange);
      return;
    }

    String? diagName;
    String? diagRatio;

    if (state.includeDiagnosis && hasDiagnosis) {
      diagName = diagnosisState.diagnosisResult!.conditionName;
      diagRatio = diagnosisState.diagnosisResult!.confidenceWithoutPercent;
    }

    context.read<BookingCubit>().bookAppointment(
      _noteController.text,
      diagnosisName: diagName,
      diagnosisRatio: diagRatio,
      isEmergency:
          state.isEmergency ||
          (state.includeDiagnosis &&
              (diagnosisState.diagnosisResult?.isEmergency ?? false)),
    );
  }

  String? _validateBookingDetails(BuildContext context, BookingSuccess state) {
    if (state.departmentType.requiresImageType &&
        (state.imageType == null || state.imageType!.trim().isEmpty)) {
      return 'please_select_image_type'.tr(context);
    }

    if (state.departmentType.requiresLabTests &&
        state.selectedLabTestIds.isEmpty) {
      return 'please_select_lab_test'.tr(context);
    }

    return null;
  }

  Future<void> _openAttachmentPicker(
    BuildContext context, {
    required String title,
    required MedicalAttachmentType type,
    required List<MedicalAttachmentItem> attachments,
    required int? selectedAttachmentId,
    required ValueChanged<MedicalAttachmentItem?> onSelected,
  }) async {
    final MedicalAttachmentItem? selected = await Navigator.of(context)
        .push<MedicalAttachmentItem>(
          MaterialPageRoute(
            builder: (_) => MedicalAttachmentPickerScreen(
              title: title,
              attachments: attachments,
              type: type,
              selectedAttachmentId: selectedAttachmentId,
            ),
          ),
        );

    if (!mounted || selected == null) {
      return;
    }

    onSelected(selected);
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
                  "attach_diagnosis_result".tr(context),
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
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryColors.withValues(alpha: 0.2),
                ),
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
                    diagnosisState.diagnosisResult?.conditionName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColors,
                    ),
                  ),
                  Text(
                    "${"confidence".tr(context)}: ${diagnosisState.diagnosisResult?.confidence ?? ''}",
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
