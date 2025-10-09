import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failuer.dart';
import '../../models/user_model.dart';

abstract class LoginRepo {
  Future<Either<Failure, UserModel>> login(String pass, String phone);
}
