import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL']!;

  // ------------------ AUTH Endpoints ------------------
  static const String sendOtp = "/auth/send-otp"; // POST
  static const String verifyOtp = "/auth/verify-otp"; // POST
  static const String me = "/me"; // GET
  static const String logout = "/logout"; // POST

  // ------------------ CUSTOMER ----------------
  static const String ledger = "/customer/ledger"; // GET
  static const String orders = "/customer/orders"; // GET
  static const String orderPlace = "/customer/orders"; // POST
  static const String getOrder = "/customer/orders/{id}"; // GET
  static const String products = "/customer/products"; // GET
  static const String profile = "/customer/profile"; // GET
  static const String updateProfile = "/customer/profile"; // PUT

  // Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String acceptLanguage = "Accept-Language";

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
