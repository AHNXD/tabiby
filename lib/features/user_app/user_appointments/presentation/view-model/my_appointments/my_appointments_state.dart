part of 'my_appointments_cubit.dart';

sealed class MyAppointmentsState extends Equatable {
  const MyAppointmentsState();

  @override
  List<Object?> get props => [];
}

final class MyAppointmentsInitial extends MyAppointmentsState {}

final class MyAppointmentsoading extends MyAppointmentsState {}

final class MyAppointmentsError extends MyAppointmentsState {
  final String errorMsg;

  const MyAppointmentsError({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

final class MyAppointmentsSuccess extends MyAppointmentsState {
  final Appointments myAppointments;
  final int? cancelingAppointmentId;
  final String actionMessage;
  final String actionErrorMessage;

  const MyAppointmentsSuccess({
    required this.myAppointments,
    this.cancelingAppointmentId,
    this.actionMessage = '',
    this.actionErrorMessage = '',
  });

  MyAppointmentsSuccess copyWith({
    Appointments? myAppointments,
    int? cancelingAppointmentId,
    bool clearCancelingAppointmentId = false,
    String? actionMessage,
    String? actionErrorMessage,
  }) {
    return MyAppointmentsSuccess(
      myAppointments: myAppointments ?? this.myAppointments,
      cancelingAppointmentId: clearCancelingAppointmentId
          ? null
          : cancelingAppointmentId ?? this.cancelingAppointmentId,
      actionMessage: actionMessage ?? this.actionMessage,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    myAppointments,
    cancelingAppointmentId,
    actionMessage,
    actionErrorMessage,
  ];
}
