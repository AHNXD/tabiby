part of 'reset_password_cubit.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ForgetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String errorMsg;
  const ResetPasswordError({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class VerifyResetPasswordSuccess extends ResetPasswordState {}
