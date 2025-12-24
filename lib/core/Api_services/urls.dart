class Urls {
  //ip
  static String ip = "192.168.6.169";

  //base urls
  static String baseUrl = "http://$ip:";

  //assets urls
  static String assetsBaseUrl = "http://$ip/storage/app/public/";

  //auth endpoint
  static String login = "8000/api/login";
  static String logout = "8000/api/logout";
  static String register = "8000/api/register";
  static String verifiPhoneNum = "8000/api/verify-account";
  static String forgetPassword = "8000/api/forget-password";
  static String verfiResetPassword = "8000/api/verify-reset-password";
  static String resendCode = "8000/api/resend-code";

  //profile endpoint
  static String getProfile = "8000/api/get_profile";
  static String updateProfile = "8000/api/update_profile";
  static String deleteProfile = "8000/api/delete_account";

  //Specialists endpoint
  static const String specialists = "8000/api/get_all_specialties";

  //Doctors endpoint
  static const String doctors = "8000/api/get_all_doctors";
  static const String doctor = "8000/api/get_doctor";

  //Centers endpoint
  static const String centers = "8000/api/get_all_clinic_centers";
  static const String center = "8000/api/get_clinic_center";

  //Home endpoint
  static const String home = "8000/api/home";

  //appointments
  static const getCenters = "8000/api/get_doctor_centers";
  static const getDays = "8000/api/get_30_days";
  static const getTimes = "8000/api/get_times_today";
  static const addAppointment = "8000/api/appointment";
  static const getAppointments = "8000/api/appointments";
  static const getMyAppointments = "8000/api/appointments";

  //Diagnose endpoints
  static const String categories = "8001/api/v1/categories";
  static String questions(int categoryId) =>
      "8001/api/v1/categories/$categoryId/questions";
  static const String diagnose = "8001/api/v1/diagnose";
}
