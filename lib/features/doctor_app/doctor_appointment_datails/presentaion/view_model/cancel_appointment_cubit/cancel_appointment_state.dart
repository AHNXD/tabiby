abstract class CancelAppointmentState {}

class CancelAppointmentInitial extends CancelAppointmentState {}

class CancelAppointmentLoading extends CancelAppointmentState {}

class CancelAppointmentSuccess extends CancelAppointmentState {
  final String message;
  CancelAppointmentSuccess(this.message);
}

class CancelAppointmentFailure extends CancelAppointmentState {
  final String error;
  CancelAppointmentFailure(this.error);
}
