import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tabiby/features/auth/data/repos/register_repo/register_repo.dart';
import 'package:tabiby/features/auth/data/repos/register_repo/register_repo_iplm.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository_iplm.dart';
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

  // auth singleton
  getit.registerSingleton<RegisterRepo>(
    RegisterRepoIplm(getit.get<ApiServices>()),
  );

  //Diagnose
  getit.registerSingleton<DiagnosisRepository>(
    DiagnosisRepositoryIplm(getit.get<ApiServices>()),
  );
}
