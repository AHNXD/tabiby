class Urls {
  //ip
  static String ip = "192.168.1.3";

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

  //auth endpoint
  static String login = "$basePort/login";
  static String logout = "$basePort/logout";
  static String register = "$basePort/register";

  //reset password endpoint
  static String forgetPassword = "$basePort/password/forget_password";
  static String resetPasswordInApp(String password, String confirmPassword) =>
      "$basePort/reset_password_after_auth?password=$password&password_confirmation=$confirmPassword";
  static String resetPassword(int otp, String password) =>
      "$basePort/password/reset_password?otp=$otp&password=$password";

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
  static String labTests = "$basePort/lab-tests";
  static String labTestsByCenter(int centerId) =>
      "$labTests?center_id=$centerId";
  static String getAppointments = "$basePort/appointments";
  static String getMyAppointments = "$basePort/appointments";
  static String notifications = "$basePort/notifications";
  static String fcmToken = "$basePort/fcm-token";
  static String markNotificationAsRead(String notificationId) =>
      "$notifications/$notificationId/read";

  //medical files
  static String medicalImageTypes = "$basePort/medical-image-types";
  static String medicalImageTypesByCenter(int centerId) =>
      "$medicalImageTypes?center_id=$centerId";
  static String uploadPatientMedicalRecord =
      "$basePort/patient/medical_record/stroe";
  static String patientUploadedMedicalRecords =
      "$basePort/patient/medical_record/show_all";
  static String patientMedicalRecords = "$basePort/patient/medical-records";

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

  // AI proxy endpoints
  static String aiGenerateDietPlan = "$basePort/ai/generate-diet-plan";
  static String aiAnalyzeXray = "$basePort/ai/analyze-xray";
  static String aiGetSymptoms = "$basePort/ai/get-symptoms";
  static String aiDiagnose = "$basePort/ai/diagnose";
  static String nutritionPlans = "$basePort/nutrition-plans";
  static String latestNutritionPlan = "$nutritionPlans/latest";
  static String nutritionPlanById(String id) => "$nutritionPlans/$id";

  // AI usage limits
  static String aiRemaining = "$basePort/ai/remaining";
}
