import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failuer.dart';
import '../../models/user_model.dart';

abstract class RegisterRepo {
  Future<Either<Failure, String>> register(Map<String, dynamic> registerData);
  Future<Either<Failure, UserModel>> verifiPhoneNum({
    required String phoneNumber,
    required String code,
  });
}
