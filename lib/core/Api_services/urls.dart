class Urls {
  //base urls
  static String ip = "192.168.1.11:8000";
  static String baseUrl = "http://$ip/api/";

  //auth endpoint
  static String login = "login";
  static String logout = "logout";
  static String register = "register";
  static String verifiPhoneNum = "verify-account";
  static String forgetPassword = "forget-password";
  static String verfiResetPassword = "verify-reset-password";
  static String resendCode = "resend-code";
  static String getProfile = "get_profile";

  //Specialists endpoint
  static const String specialists = "get_all_specialties";

  //Home endpoint
  static const String home = "home";

  //Diagnose endpoints
  static const String categories = "v1/categories";
  static String questions(int categoryId) =>
      "v1/categories/$categoryId/questions";
  static const String diagnose = "v1/diagnose";
}
