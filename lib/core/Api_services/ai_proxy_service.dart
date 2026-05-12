import 'package:dio/dio.dart';

import '../errors/ai_exception.dart';
import 'api_services.dart';
import 'urls.dart';

class AiProxyService {
  AiProxyService(this._apiServices);

  final ApiServices _apiServices;

  Future<dynamic> generateDietPlan(Map<String, dynamic> payload) {
    return _postJson(
      endPoint: Urls.aiGenerateDietPlan,
      payload: payload,
      timeout: const Duration(minutes: 5),
    );
  }

  Future<dynamic> analyzeXray(Map<String, dynamic> payload) {
    return _postJson(
      endPoint: Urls.aiAnalyzeXray,
      payload: payload,
      timeout: const Duration(minutes: 2),
    );
  }

  Future<dynamic> getSymptoms(Map<String, dynamic> payload) {
    return _postJson(endPoint: Urls.aiGetSymptoms, payload: payload);
  }

  Future<dynamic> diagnose(Map<String, dynamic> payload) {
    return _postJson(endPoint: Urls.aiDiagnose, payload: payload);
  }

  Future<dynamic> _postJson({
    required String endPoint,
    required Map<String, dynamic> payload,
    Duration? timeout,
  }) async {
    try {
      final response = await _apiServices.post(
        endPoint: endPoint,
        data: payload,
        sendTimeout: timeout,
        receiveTimeout: timeout,
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw AiException.fromStatusCode(response.statusCode);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        throw AiException.fromStatusCode(statusCode);
      }

      throw const AiException(AiException.serviceUnavailable);
    }
  }
}
