class Urls {
  //base urls
  static String ip = "192.168.1.2:5000";
  static String baseUrl = "http://$ip/api/v1/";

  //auth endpoint
  static String login = "auth/login";
  static String logout = "auth/logout";
  static String register = "auth/register";
  static String verifiPhoneNum = "auth/verify-account";
  static String forgetPassword = "auth/forget-password";
  static String verfiResetPassword = "auth/verify-reset-password";
  static String resendCode = "/auth/resend-code";
  static String getProfile = "/auth/me";

  static const String categories = "/categories";
  static String questions(int categoryId) =>
      "/categories/$categoryId/questions";
  static const String diagnose = "diagnose";
}
