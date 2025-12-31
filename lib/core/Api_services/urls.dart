class Urls {
  //ip
  static String ip = "192.168.100.205";

  static String fixUrl(String url) {
    if (url.contains("127.0.0.1")) {
      return url.replaceAll("127.0.0.1", ip);
    }
    if (url.contains("localhost")) {
      return url.replaceAll("localhost", ip);
    }
    return url;
  }

  //base urls
  static String baseUrl = "http://$ip:";

  //ports
  static String basePort = "8000/api";
  static String aiPort = "8001/api";

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

  //doctors appointment details endpoint
  static String doctorAppointmentDetails = "$basePort/appointment_details";

  //cancel appointment endpoint
  static String cancelAppointment = "$basePort/appointments/cancel";

  //end appointment endpoint
  static String endAppointment = "$basePort/doctor/appointments/end";

  //rating appointment endpoint
  static String checkAppointment(int appointmentID) =>
      "$basePort/patient/appointments/$appointmentID/rating";

  static String addRate = "$basePort/patient/appointments/rate";

  //Diagnose endpoints
  static String categories = "$aiPort/v1/categories";
  static String questions(int categoryId) =>
      "$aiPort/v1/categories/$categoryId/questions";
  static String diagnose = "$aiPort/v1/diagnose";
}
