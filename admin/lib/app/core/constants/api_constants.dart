import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['BASE_URL']!;

  // ------------------ AUTH Endpoints ------------------
  static const String sendOtp = "/auth/send-otp"; // POST
  static const String verifyOtp = "/auth/verify-otp"; // POST
  static const String me = "/me"; // GET
  static const String logout = "/logout"; // POST

  // ------------------ ADMIN ----------------
  static const String customers = "/admin/customers"; // GET
  static const String getCustomer = "/admin/customers/{id}"; // GET
  static const String updateCustomer = "/admin/customers/{id}"; // PUT

  static const String deliveryStockIssue =
      "/admin/delivery-stock/issue"; // POST
  static const String deliveryStockReturn =
      "/admin/delivery-stock/return"; // POST

  static const String customerLedger = "/admin/customers/{id}/ledger"; // GET

  static const String orders = "/admin/orders"; // GET
  static const String getOrder = "/admin/orders/{id}"; // GET
  static const String assignOrder =
      "/admin/orders/{id}/assign-delivery"; // POST

  static const String products = "/admin/products"; // GET
  static const String createProduct = "/admin/products"; // POST
  static const String getProduct = "/admin/products/{id}"; // GET
  static const String updateProduct = "/admin/products/{id}"; // PUT
  static const String deleteProduct = "/admin/products/{id}"; // DELETE

  static const String regions = "/admin/regions"; // GET
  static const String createRegions = "/admin/regions"; // POST
  static const String getRegion = "/admin/regions/{id}"; // GET
  static const String updateRegion = "/admin/regions/{id}"; // PUT
  static const String deleteRegion = "/admin/regions/{id}"; // DELETE
  static const String assignRegion = "/admin/regions/{id}/assign-user"; // POST

  // Headers
  static const String contentType = "application/json";
  static const String authorization = "Authorization";
  static const String acceptLanguage = "Accept-Language";

  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
