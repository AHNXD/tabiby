import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repos/register_repo/register_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerRepo) : super(RegisterInitial());

  final RegisterRepo _registerRepo;

  Future register(Map<String, dynamic> registerData) async {
    emit(RegisterLoading());
    var data = await _registerRepo.register(registerData);
    data.fold((failure) => emit(RegisterError(errorMsg: failure.message)), (
      phoneNum,
    ) {
      emit(RegisterSuccess(phoneNum: phoneNum));
    });
  }

  Future verifiPhoneNum({required String phone, required String code}) async {
    emit(VerifiPhoneLoading());
    var data = await _registerRepo.verifiPhoneNum(
      phoneNumber: phone,
      code: code,
    );
    data.fold(
      (failure) => emit(VerifiPhoneError(errorMsg: failure.message)),
      (user) => emit(VerifiPhoneSuccess(user: user)),
    );
  }
}
