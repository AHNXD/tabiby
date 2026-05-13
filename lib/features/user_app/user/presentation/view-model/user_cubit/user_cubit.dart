import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/data/models/user_model.dart';
import '../../../data/repos/user_repo.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepo) : super(UserInitial());

  final UserRepo _userRepo;
  int _sessionVersion = 0;

  Future getProfile() async {
    final int sessionVersion = _sessionVersion;
    emit(UserLoading());
    var data = await _userRepo.getProfile();
    if (sessionVersion != _sessionVersion) {
      return;
    }

    data.fold((failure) => emit(UserError(errorMsg: failure.message)), (user) {
      emit(UserSuccess(user: user));
    });
  }

  Future updateProfile(Map<String, dynamic> registerData) async {
    final int sessionVersion = _sessionVersion;
    emit(UserLoading());
    var data = await _userRepo.updateProfile(registerData);
    if (sessionVersion != _sessionVersion) {
      return;
    }

    data.fold((failure) => emit(UserError(errorMsg: failure.message)), (user) {
      emit(UserSuccess(user: user));
    });
  }

  Future deleteProfile() async {
    final int sessionVersion = _sessionVersion;
    emit(UserLoading());
    var data = await _userRepo.deleteProfile();
    if (sessionVersion != _sessionVersion) {
      return;
    }

    data.fold((failure) => emit(UserError(errorMsg: failure.message)), (state) {
      emit(UserDeleteSuccess());
    });
  }

  void reset() {
    _sessionVersion++;
    emit(UserInitial());
  }
}
