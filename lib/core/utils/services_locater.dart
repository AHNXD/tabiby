import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../Api_services/api_services.dart';

final getit = GetIt.instance;

void setupLocatorServices() {
  // init Dio
  getit.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        connectTimeout: Duration(minutes: 1),
        sendTimeout: const Duration(minutes: 1),
        receiveTimeout: Duration(minutes: 1),
      ),
    ),
  );
  // init API Service
  getit.registerLazySingleton<ApiServices>(() => ApiServices(getit.get<Dio>()));

  //auth singleton
  // getit.registerSingleton<LoginRepo>(LoginRepoIpml(getit.get<ApiServices>()));
}
