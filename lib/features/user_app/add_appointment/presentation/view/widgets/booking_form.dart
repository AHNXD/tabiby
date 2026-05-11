import 'package:flutter/material.dart';
import 'package:tabiby/core/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/core/utils/app_localizations.dart';
import 'package:tabiby/core/utils/functions.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/booking_request_model.dart';
import 'package:tabiby/features/user_app/add_appointment/data/models/medical_attachment_item.dart';
import 'package:tabiby/features/user_app/diagnose/data/models/diagnosis_result_model.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/view_models/diagnosis_cubit.dart';

import '../../../../../../core/widgets/primary_button.dart';
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
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is AppointmentBookedSuccessfully) {
          messages(
            context,
            'booking_request_sent'.tr(context),
            AppColors.greenColor,
          );
          Navigator.pop(context);
        }
        if (state is BookingFailure) {
          messages(context, state.errMessage, AppColors.redColor);
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
          return _buildBookingContent(context, bookingState);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBookingContent(BuildContext context, BookingSuccess state) {
    final DiagnosisResult? diagnosisResult = context
        .watch<DiagnosisCubit>()
        .state
        .diagnosisResult;
    final bool canSendDiagnosisResult =
        state.departmentType == BookingDepartmentType.doctor &&
        diagnosisResult != null;
    final bool showDateTimeStep = state.selectedCenterId != null;
    final bool showDetailsStep = state.selectedTime != null;
    final bool detailsStepCompleted = _hasCompletedDetailsStep(state);
    final bool showNotesStep = showDetailsStep && detailsStepCompleted;
    final int currentStep = _resolveCurrentStep(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _BookingProgressHeader(currentStep: currentStep),
        const SizedBox(height: 18),
        _StepCard(
          child: CenterSection(
            centers: state.centers,
            selectedId: state.selectedCenterId,
            onSelect: (int id) => context.read<BookingCubit>().selectCenter(id),
          ),
        ),
        if (showDateTimeStep) ...<Widget>[
          const SizedBox(height: 16),
          _StepCard(
            child: state.isLoadingDays
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : state.days.isNotEmpty
                ? DateTimeSection(
                    days: state.days,
                    selectedDate: state.selectedDate,
                    onSelectDate: (String day) =>
                        context.read<BookingCubit>().selectDay(day),
                    isLoadingTimes: state.isLoadingTimes,
                    periods: state.times?.periods,
                    selectedTimeSlot: state.selectedTime,
                    selectedPeriodName: state.selectedPeriodName,
                    onSelectTimeSlot: (time, category) {
                      context.read<BookingCubit>().selectTime(time, category);
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
        if (showDetailsStep) ...<Widget>[
          const SizedBox(height: 16),
          _StepCard(
            child: AppointmentDetailsSection(
              departmentType: state.departmentType,
              availableLabTests: state.availableLabTests,
              selectedLabTestIds: state.selectedLabTestIds,
              availableMedicalImageTypes: state.availableMedicalImageTypes,
              selectedMedicalImageTypeId: state.selectedMedicalImageTypeId,
              onMedicalImageTypeChanged: context
                  .read<BookingCubit>()
                  .updateMedicalImageType,
              onToggleLabTest: context
                  .read<BookingCubit>()
                  .toggleLabTestSelection,
              selectedMedicalAttachments: state.selectedMedicalAttachments,
              availableMedicalAttachments: state.availableMedicalAttachments,
              onPickMedicalRecords: () => _openAttachmentPicker(
                context,
                attachments: state.availableMedicalAttachments,
                selectedAttachments: state.selectedMedicalAttachments,
              ),
              onClearMedicalRecords: () =>
                  context.read<BookingCubit>().updateSelectedMedicalAttachments(
                    const <MedicalAttachmentItem>[],
                  ),
            ),
          ),
        ],
        if (showNotesStep) ...<Widget>[
          const SizedBox(height: 16),
          _StepCard(
            child: NotesSection(
              noteController: _noteController,
              showDiagnosisOption: canSendDiagnosisResult,
              sendDiagnosisResult: state.sendDiagnosisResult,
              diagnosisResult: diagnosisResult,
              onToggleSendDiagnosis: context
                  .read<BookingCubit>()
                  .updateSendDiagnosisResult,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: state.isBooking
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'book_an_appointment'.tr(context),
                      onPressed: () => _submitBooking(context, state),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  void _submitBooking(BuildContext context, BookingSuccess state) {
    final DiagnosisResult? diagnosisResult = context
        .read<DiagnosisCubit>()
        .state
        .diagnosisResult;
    if (state.selectedTime == null) {
      messages(
        context,
        'please_select_time'.tr(context),
        AppColors.orangeColor,
      );
      return;
    }

    final String? detailsValidationMessage = _validateBookingDetails(
      context,
      state,
    );
    if (detailsValidationMessage != null) {
      messages(context, detailsValidationMessage, AppColors.orangeColor);
      return;
    }

    context.read<BookingCubit>().bookAppointment(
      _noteController.text,
      diagnosis: diagnosisResult == null
          ? null
          : <String, dynamic>{
              'condition_name': diagnosisResult.conditionName,
              'confidence': diagnosisResult.confidence,
              'specialist': diagnosisResult.specialist,
            },
      diagnosisRatio: _parseDiagnosisRatio(diagnosisResult),
      diagnosisName: diagnosisResult?.conditionName,
      isEmergency: diagnosisResult?.isEmergency,
    );
  }

  String? _validateBookingDetails(BuildContext context, BookingSuccess state) {
    if (state.departmentType.requiresImageType &&
        state.selectedMedicalImageTypeId == null) {
      return 'please_select_image_type'.tr(context);
    }

    if (state.departmentType.requiresLabTests &&
        state.selectedLabTestIds.isEmpty) {
      return 'please_select_lab_test'.tr(context);
    }

    return null;
  }

  double? _parseDiagnosisRatio(DiagnosisResult? diagnosisResult) {
    if (diagnosisResult == null) {
      return null;
    }

    return double.tryParse(diagnosisResult.confidenceWithoutPercent);
  }

  bool _hasCompletedDetailsStep(BookingSuccess state) {
    if (state.departmentType.requiresImageType) {
      return state.selectedMedicalImageTypeId != null;
    }

    if (state.departmentType.requiresLabTests) {
      return state.selectedLabTestIds.isNotEmpty;
    }

    return true;
  }

  int _resolveCurrentStep(BookingSuccess state) {
    if (state.selectedCenterId == null) {
      return 1;
    }

    if (state.selectedTime == null) {
      return 2;
    }

    if (!_hasCompletedDetailsStep(state)) {
      return 3;
    }

    return 4;
  }

  Future<void> _openAttachmentPicker(
    BuildContext context, {
    required List<MedicalAttachmentItem> attachments,
    required List<MedicalAttachmentItem> selectedAttachments,
  }) async {
    final BookingCubit bookingCubit = context.read<BookingCubit>();
    final List<MedicalAttachmentItem>? selected = await Navigator.of(context)
        .push<List<MedicalAttachmentItem>>(
          MaterialPageRoute(
            builder: (_) => MedicalAttachmentPickerScreen(
              title: 'pick_medical_records'.tr(context),
              attachments: attachments,
              selectedAttachmentKeys: selectedAttachments
                  .map((MedicalAttachmentItem item) => item.selectionKey)
                  .toSet(),
            ),
          ),
        );

    if (!mounted || selected == null) {
      return;
    }

    bookingCubit.updateSelectedMedicalAttachments(selected);
  }
}

class _BookingProgressHeader extends StatelessWidget {
  const _BookingProgressHeader({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryColors.withValues(alpha: 0.14),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryColors.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$currentStep',
                  style: const TextStyle(
                    color: AppColors.forestAccentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _stepLabel(context, currentStep),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.forestDeepColor,
                  ),
                ),
              ),
              Text(
                '$currentStep/4',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.forestHintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List<Widget>.generate(4, (int index) {
              final int stepNumber = index + 1;
              final bool isActive = stepNumber <= currentStep;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: index == 3 ? 0 : 6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryColors
                          : AppColors.sageSurfaceColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _stepLabel(BuildContext context, int step) {
    switch (step) {
      case 1:
        return 'select_a_center'.tr(context);
      case 2:
        return 'select_date_and_time'.tr(context);
      case 3:
        return 'appointment_details'.tr(context);
      case 4:
        return 'add_notes'.tr(context);
      default:
        return '';
    }
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sageBorderSoftColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
