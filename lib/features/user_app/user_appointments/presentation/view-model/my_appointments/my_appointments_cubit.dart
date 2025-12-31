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
}
