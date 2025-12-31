import 'package:dartz/dartz.dart';
import '../../../../../../core/Api_services/api_services.dart';
import '../../../../../../core/Api_services/urls.dart';
import '../../../../../../core/errors/error_handler.dart';
import '../../../../../../core/errors/failuer.dart';
import '../../models/rating_status_model.dart';
import 'rating_repo.dart';

class RatingRepoIplm implements RatingRepo {
  final ApiServices _apiServices;

  RatingRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, bool>> addRate(
    int id,
    int rate,
    String comment,
  ) async {
    try {
      var resp = await _apiServices.post(
        endPoint: Urls.addRate,
        data: {"appointment_id": id, "rating": rate, "comment": comment},
      );

      if (resp.statusCode == 200 && resp.data['status']) {
        return right(true);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatingStatus>> checkAppointment(int id) async {
    try {
      var resp = await _apiServices.get(endPoint: Urls.checkAppointment(id));

      if (resp.statusCode == 200 && resp.data['status']) {
        RatingStatus ratingStatus = RatingStatus.fromJson(resp.data['data']);

        return right(ratingStatus);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
