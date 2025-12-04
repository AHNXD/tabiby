import 'package:dartz/dartz.dart';
import 'package:tabiby/features/auth/data/models/user_model.dart';
import '../../../../../core/errors/failuer.dart';

abstract class RegisterRepo {
  Future<Either<Failure, UserModel>> register(
    Map<String, dynamic> registerData,
  );
}
