abstract class EndAppointmentState {}

class EndAppointmentInitial extends EndAppointmentState {}

class EndAppointmentLoading extends EndAppointmentState {}

class EndAppointmentSuccess extends EndAppointmentState {
  final String message;
  EndAppointmentSuccess(this.message);
}

class EndAppointmentFailure extends EndAppointmentState {
  final String error;
  EndAppointmentFailure(this.error);
}
