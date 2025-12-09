import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/data/models/user_model.dart';
import '../../../data/repos/user_repo.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepo) : super(UserInitial());

  final UserRepo _userRepo;

  Future getProfile() async {
    emit(UserLoading());
    var data = await _userRepo.getProfile();
    data.fold((failure) => emit(UserError(errorMsg: failure.message)), (user) {
      emit(UserSuccess(user: user));
    });
  }

  Future updateProfile(Map<String, dynamic> registerData) async {
    emit(UserLoading());
    var data = await _userRepo.updateProfile(registerData);
    data.fold((failure) => emit(UserError(errorMsg: failure.message)), (user) {
      emit(UserSuccess(user: user));
    });
  }
}
