class AppUrl {
  // static const String liveBaseURL = "https://remote-ur/api/v1";
  static const String localBaseURL = "http://192.168.1.3:3006";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/customer/signin";
  static const String register = baseURL + "/customer/signup";
  static const String collectedBill = baseURL + "/collected-bill";
  static const String visitedStore = baseURL + "/visited-store";
  static const String billApp = baseURL + "/bill/app-find";
  // static const String forgotPassword = baseURL + "/forgot-password";
}
