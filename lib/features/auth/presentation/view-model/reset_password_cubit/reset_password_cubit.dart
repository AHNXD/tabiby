import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repos/reset_password_repo/reset_password_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepo _resetPasswordRepo;
  ResetPasswordCubit(this._resetPasswordRepo) : super(ResetPasswordInitial());

  Future<void> forgetPassword({required String email}) async {
    emit(ResetPasswordLoading());
    final result = await _resetPasswordRepo.forgetPassword(email: email);
    result.fold(
      (failure) => emit(ResetPasswordError(errorMsg: failure.message)),
      (phone) => emit(ForgetPasswordSuccess()),
    );
  }

  void resetPasswordInApp({
    required String password,
    required String confirmPassword,
  }) async {
    emit(ResetPasswordLoading());
    final result = await _resetPasswordRepo.resetPasswordInApp(
      password: password,
      confirmPassword: confirmPassword,
    );
    result.fold(
      (failure) => emit(ResetPasswordError(errorMsg: failure.message)),
      (message) => emit(VerifyResetPasswordSuccess()),
    );
  }

  void resetPassword({
    required int otp,
    required String password,
    required String email,
  }) async {
    emit(ResetPasswordLoading());
    final result = await _resetPasswordRepo.resetPassword(
      otp: otp,
      password: password,
      email: email,
    );
    result.fold(
      (failure) => emit(ResetPasswordError(errorMsg: failure.message)),
      (message) => emit(VerifyResetPasswordSuccess()),
    );
  }
}
