import 'package:equatable/equatable.dart';

import '../../../data/models/appointment_request_option.dart';
import '../../../data/models/end_appointment_result.dart';

const Object _unset = Object();

class EndAppointmentState extends Equatable {
  final bool isLoadingOptions;
  final bool isSubmitting;
  final bool hasPharmacy;
  final List<AppointmentRequestOption> availableLabTests;
  final List<AppointmentRequestOption> availableMedicalImageTypes;
  final String? optionsErrorMessage;
  final String? submitErrorMessage;
  final EndAppointmentResult? result;

  const EndAppointmentState({
    this.isLoadingOptions = false,
    this.isSubmitting = false,
    this.hasPharmacy = false,
    this.availableLabTests = const <AppointmentRequestOption>[],
    this.availableMedicalImageTypes = const <AppointmentRequestOption>[],
    this.optionsErrorMessage,
    this.submitErrorMessage,
    this.result,
  });

  EndAppointmentState copyWith({
    bool? isLoadingOptions,
    bool? isSubmitting,
    bool? hasPharmacy,
    List<AppointmentRequestOption>? availableLabTests,
    List<AppointmentRequestOption>? availableMedicalImageTypes,
    Object? optionsErrorMessage = _unset,
    Object? submitErrorMessage = _unset,
    Object? result = _unset,
  }) {
    return EndAppointmentState(
      isLoadingOptions: isLoadingOptions ?? this.isLoadingOptions,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      hasPharmacy: hasPharmacy ?? this.hasPharmacy,
      availableLabTests: availableLabTests ?? this.availableLabTests,
      availableMedicalImageTypes:
          availableMedicalImageTypes ?? this.availableMedicalImageTypes,
      optionsErrorMessage: identical(optionsErrorMessage, _unset)
          ? this.optionsErrorMessage
          : optionsErrorMessage as String?,
      submitErrorMessage: identical(submitErrorMessage, _unset)
          ? this.submitErrorMessage
          : submitErrorMessage as String?,
      result: identical(result, _unset)
          ? this.result
          : result as EndAppointmentResult?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    isLoadingOptions,
    isSubmitting,
    hasPharmacy,
    availableLabTests,
    availableMedicalImageTypes,
    optionsErrorMessage,
    submitErrorMessage,
    result,
  ];
}
