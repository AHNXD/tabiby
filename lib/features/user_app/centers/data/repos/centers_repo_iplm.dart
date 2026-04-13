import 'package:dartz/dartz.dart';
import '../../../../../core/Api_services/api_services.dart';
import '../../../../../core/Api_services/urls.dart';
import '../../../../../core/errors/error_handler.dart';
import '../../../../../core/errors/failuer.dart';
import '../models/centers_query_params.dart';
import '../../../center_details/data/models/centers_model.dart';
import 'centers_repo.dart';

class CentersRepoIplm implements CentersRepo {
  final ApiServices _apiServices;

  CentersRepoIplm(this._apiServices);

  @override
  Future<Either<Failure, CentersModel>> getCenters(
    int page,
    CentersQueryParams queryParams,
  ) async {
    try {
      String endpoint = Urls.centers;
      final String queryString = Uri(
        queryParameters: queryParams.toQueryParameters(page: page),
      ).query;
      endpoint += '?$queryString';
      var resp = await _apiServices.get(endPoint: endpoint);

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        CentersModel centers = CentersModel.fromJson(resp.data['data']);

        return right(centers);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Centers>> getCenter(int centerID) async {
    try {
      var resp = await _apiServices.get(endPoint: "${Urls.center}/$centerID");

      if (resp.statusCode == 200 && resp.data['status'] == true) {
        Centers center = Centers.fromJson(resp.data['data']['center']);

        return right(center);
      }

      return left(
        ServerFailure(resp.data['message'] ?? ErrorHandler.defaultMessage()),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
