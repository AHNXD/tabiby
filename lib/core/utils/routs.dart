import 'package:flutter/material.dart';
import 'package:tabiby/features/shared/splash/presentation/view/splash_screen.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/category_screen.dart';
import 'package:tabiby/features/user_app/diagnose/presentation/views/question_screen.dart';

import '../../features/auth/presentation/views/login/view/login_screen.dart';
import '../../features/auth/presentation/views/sign_up/view/sign_up_screen.dart';
import '../../features/doctor_app/appointment_details_doctor/view/appointment_details_screen.dart';
import '../../features/doctor_app/doctor_dashboard/view/doctor_dashboard_screen.dart';
import '../../features/shared/settings/view/settings_screen.dart';
import '../../features/shared/welcome/view/welcome_screen.dart';
import '../../features/user_app/add_appointment/view/booking_screen.dart';
import '../../features/user_app/categories/presentation/view/all_categories_screen.dart';
import '../../features/user_app/center_details/view/center_details_screen.dart';
import '../../features/user_app/centers/presentation/view/all_centers_screen.dart';
import '../../features/user_app/diagnose/presentation/views/result_screen.dart';
import '../../features/user_app/doctor_details/view/doctor_details_screen.dart';
import '../../features/user_app/doctors/presentation/view/all_doctors_screen.dart';
import '../../features/user_app/home/presentation/view/home_screen.dart';
import '../../features/user_app/user/view/user_profile.dart';
import '../../features/user_app/user_appointments/view/appointment_screen.dart';
import '../widgets/main_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> routes = {
    //auth
    LoginScreen.routeName: (context) => LoginScreen(),
    SignUpScreen.routeName: (context) => SignUpScreen(),

    //user
    HomeScreen.routeName: (context) => HomeScreen(),
    BookingScreen.routeName: (context) => BookingScreen(),
    AllCategoriesScreen.routeName: (context) =>
        AllCategoriesScreen(categories: []),
    CenterDetailsScreen.routeName: (context) => CenterDetailsScreen(center: {}),
    AllCentersScreen.routeName: (context) =>
        AllCentersScreen(medicalCenters: []),
    DoctorDetailsScreen.routeName: (context) => DoctorDetailsScreen(
      doctorName: '',
      specialty: '',
      experience: '',
      imageUrl: '',
      rating: '',
    ),
    AllDoctorsScreen.routeName: (context) => AllDoctorsScreen(doctors: []),
    UserProfileScreen.routeName: (context) => UserProfileScreen(),
    UserAppointmentScreen.routeName: (context) => UserAppointmentScreen(),
    MainScreen.routeName: (context) => MainScreen(),

    //doctor
    AppointmentDetailsDoctor.routeName: (context) =>
        AppointmentDetailsDoctor(appointment: {}),
    DoctorDashboardScreen.routeName: (context) => DoctorDashboardScreen(),

    //shared
    SettingsScreen.routeName: (context) => SettingsScreen(),
    WelcomeScreen.routeName: (context) => WelcomeScreen(),
    SplashScreen.routeName: (context) => SplashScreen(),

    //Diagnosis
    CategoryScreen.routeName: (context) => CategoryScreen(),
    QuestionScreen.routeName: (context) => QuestionScreen(),
    ResultScreen.routeName: (context) => ResultScreen(),
  };
}
