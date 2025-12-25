import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tabiby/features/auth/data/repos/logout_repo/logout_repo.dart';
import 'package:tabiby/features/auth/data/repos/register_repo/register_repo.dart';
import 'package:tabiby/features/auth/data/repos/register_repo/register_repo_iplm.dart';
import 'package:tabiby/features/user_app/add_appointment/data/repos/add_appoinment_repo.dart';
import 'package:tabiby/features/user_app/add_appointment/data/repos/add_appoinment_repo_iplm.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository.dart';
import 'package:tabiby/features/user_app/diagnose/data/repos/diagnosis_repository_iplm.dart';
import 'package:tabiby/features/user_app/user_appointments/data/repos/my_appointments_repo.dart';
import '../../features/auth/data/repos/login_repo/login_repo.dart';
import '../../features/auth/data/repos/login_repo/login_repo_ipml.dart';
import '../../features/auth/data/repos/logout_repo/logout_repo_iplm.dart';
import '../../features/doctor_app/doctor_appointment/data/repos/doctor_appointment_repo.dart' show DoctorAppointmentsRepo;
import '../../features/doctor_app/doctor_appointment/data/repos/doctor_appointments_repo_iplm.dart' show DoctorAppointmentRepoIplm;
import '../../features/user_app/centers/data/repos/centers_repo.dart';
import '../../features/user_app/centers/data/repos/centers_repo_iplm.dart';
import '../../features/user_app/doctors/data/repos/doctors_repo.dart';
import '../../features/user_app/doctors/data/repos/doctors_repo_iplm.dart';
import '../../features/user_app/home/data/repo/home_repo.dart';
import '../../features/user_app/home/data/repo/home_repo_iplm.dart';
import '../../features/user_app/specialties/data/repos/user_repo.dart';
import '../../features/user_app/specialties/data/repos/user_repo_iplm.dart';
import '../../features/user_app/user/data/repos/user_repo.dart';
import '../../features/user_app/user/data/repos/user_repo_iplm.dart';
import '../../features/user_app/user_appointments/data/repos/my_appointments_repo_iplm.dart';
import '../Api_services/api_services.dart';
import '../locale/locale_cubit.dart';

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

  getit.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
  getit.registerLazySingleton<ApiServices>(() => ApiServices(getit.get<Dio>()));

  // auth singleton
  getit.registerSingleton<RegisterRepo>(
    RegisterRepoIplm(getit.get<ApiServices>()),
  );
  getit.registerSingleton<LoginRepo>(LoginRepoIpml(getit.get<ApiServices>()));
  getit.registerSingleton<LogoutRepo>(LogoutRepoIplm(getit.get<ApiServices>()));

  //User
  getit.registerSingleton<UserRepo>(UserRepoIplm(getit.get<ApiServices>()));

  //Specialties
  getit.registerSingleton<SpecialtiesRepo>(
    SpecialtiesRepoIplm(getit.get<ApiServices>()),
  );
  //Doctors
  getit.registerSingleton<DoctorsRepo>(
    DoctorsRepoIplm(getit.get<ApiServices>()),
  );

  //Centers
  getit.registerSingleton<CentersRepo>(
    CentersRepoIplm(getit.get<ApiServices>()),
  );

  //Home
  getit.registerSingleton<HomeRepo>(HomeRepoIplm(getit.get<ApiServices>()));

  //Appointment
  getit.registerSingleton<AddAppoinmentRepo>(
    AddAppoinmentRepoIplm(getit.get<ApiServices>()),
  );
  getit.registerSingleton<MyAppointmentsRepo>(
    MyAppointmentsRepoIplm(getit.get<ApiServices>()),
  );
  //Doctor Appointments
  getit.registerSingleton<DoctorAppointmentsRepo>(
    DoctorAppointmentRepoIplm(getit.get<ApiServices>()),
  );

  //Diagnose
  getit.registerSingleton<DiagnosisRepository>(
    DiagnosisRepositoryIplm(getit.get<ApiServices>()),
  );
}
