class Urls {
  //ip
  static String ip = "192.168.1.2";

  //base urls
  static String baseUrl = "http://$ip:";

  //ports
  static String basePort = "8000/api";
  static String aiPort = "8001/api";

  //assets urls
  static String assetsBaseUrl = "http://$ip/storage/app/public/";

  //auth endpoint
  static String login = "$basePort/login";
  static String logout = "$basePort/logout";
  static String register = "$basePort/register";
  static String verifiPhoneNum = "$basePort/verify-account";
  static String forgetPassword = "$basePort/forget-password";
  static String verfiResetPassword = "$basePort/verify-reset-password";
  static String resendCode = "$basePort/resend-code";

  //profile endpoint
  static String getProfile = "$basePort/get_profile";
  static String updateProfile = "$basePort/update_profile";
  static String deleteProfile = "$basePort/delete_account";

  //Specialists endpoint
  static String specialists = "$basePort/get_all_specialties";

  //Doctors endpoint
  static String doctors = "$basePort/get_all_doctors";
  static String doctor = "$basePort/get_doctor";

  //Centers endpoint
  static String centers = "$basePort/get_all_clinic_centers";
  static String center = "$basePort/get_clinic_center";

  //Home endpoint
  static String home = "$basePort/home";

  //appointments
  static String getCenters = "$basePort/get_doctor_centers";
  static String getDays = "$basePort/get_30_days";
  static String getTimes = "$basePort/get_times_today";
  static String addAppointment = "$basePort/appointment";
  static String getAppointments = "$basePort/appointments";
  static String getMyAppointments = "$basePort/appointments";

  //doctors appointments endpoints
  static String doctorAppointments = "$basePort/doctor/appointments";

  //Diagnose endpoints
  static String categories = "$aiPort/v1/categories";
  static String questions(int categoryId) =>
      "$aiPort/v1/categories/$categoryId/questions";
  static String diagnose = "$aiPort/v1/diagnose";
}
