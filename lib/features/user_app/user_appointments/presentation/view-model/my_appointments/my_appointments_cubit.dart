import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabiby/features/user_app/user_appointments/data/models/appointments_model.dart';
import 'package:tabiby/features/user_app/user_appointments/data/repos/my_appointments/my_appointments_repo.dart';

part 'my_appointments_state.dart';

class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  MyAppointmentsCubit(this._myAppointmentsRepo)
    : super(MyAppointmentsInitial());

  final MyAppointmentsRepo _myAppointmentsRepo;

  Future getMyAppointments() async {
    emit(MyAppointmentsoading());
    var data = await _myAppointmentsRepo.getMyAppointments();
    data.fold(
      (failure) => emit(MyAppointmentsError(errorMsg: failure.message)),
      (myAppointments) {
        emit(MyAppointmentsSuccess(myAppointments: myAppointments));
      },
    );
  }

  Future<void> cancelAppointment(Appointment appointment) async {
    final currentState = state;
    final appointmentId = appointment.id;
    if (currentState is! MyAppointmentsSuccess || appointmentId == null) {
      return;
    }

    emit(
      currentState.copyWith(
        cancelingAppointmentId: appointmentId,
        actionMessage: '',
        actionErrorMessage: '',
      ),
    );

    final result = await _myAppointmentsRepo.cancelAppointment(appointmentId);
    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            clearCancelingAppointmentId: true,
            actionErrorMessage: failure.message,
            actionMessage: '',
          ),
        );
      },
      (message) {
        final updatedAppointments = _movePendingToCanceled(
          currentState.myAppointments,
          appointment,
        );
        emit(
          currentState.copyWith(
            myAppointments: updatedAppointments,
            clearCancelingAppointmentId: true,
            actionMessage: message,
            actionErrorMessage: '',
          ),
        );
      },
    );
  }

  Appointments _movePendingToCanceled(
    Appointments appointments,
    Appointment canceledAppointment,
  ) {
    final pending = List<Appointment>.from(appointments.pending ?? []);
    final canceled = List<Appointment>.from(appointments.canceled ?? []);

    pending.removeWhere(
      (appointment) => appointment.id == canceledAppointment.id,
    );
    canceled.insert(0, canceledAppointment);

    return Appointments(
      completed: appointments.completed == null
          ? null
          : List<Appointment>.from(appointments.completed!),
      pending: pending,
      canceled: canceled,
    );
  }
}
