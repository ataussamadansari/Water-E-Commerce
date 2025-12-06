import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../services/api/api_services.dart';
import '../../models/api_response_model.dart';
import '../../models/orders/orders_response.dart';
import '../../models/orders/single_order_response.dart';
import '../../models/orders/order_model.dart';

class OrdersRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  // 1. Get All Orders
  Future<ApiResponse<OrdersResponse>> getOrders() async {
    try {
      final res = await _apiServices.get<OrdersResponse>(
        ApiConstants.orders,
            (data) => OrdersResponse.fromJson(data),
        cancelToken: _cancelToken,
      );

      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!);
      } else {
        return ApiResponse.error(
          res.message,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Something went wrong",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 2. Get Order By ID
  Future<ApiResponse<Order>> getOrderById(int id) async {
    try {
      // Assuming your URL pattern is /orders/{id}
      String url = "${ApiConstants.orders}/$id";
      // Or if you have a constant: ApiConstants.getOrder.replaceAll('{id}', id.toString());

      final res = await _apiServices.get<SingleOrderResponse>(
        url,
            (data) => SingleOrderResponse.fromJson(data),
        cancelToken: _cancelToken,
      );

      // Unwrap the SingleOrderResponse to return just the Order object
      if (res.success && res.data?.data != null) {
        return ApiResponse.success(res.data!.data!);
      } else {
        return ApiResponse.error(
          res.message,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to fetch order details",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 3. Create Order (If Admin creation is allowed)
  Future<ApiResponse<Order>> createOrder(Map<String, dynamic> orderData) async {
    try {
      final res = await _apiServices.post<SingleOrderResponse>(
        ApiConstants.orders, // Assuming POST /orders
            (data) => SingleOrderResponse.fromJson(data),
        data: orderData,
        cancelToken: _cancelToken,
      );

      if (res.success && res.data?.data != null) {
        return ApiResponse.success(res.data!.data!);
      } else {
        return ApiResponse.error(
          res.message,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to create order",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 4. Update Order (General Update)
  Future<ApiResponse<Order>> updateOrder(int id, Map<String, dynamic> orderData) async {
    try {
      String url = "${ApiConstants.orders}/$id";

      final res = await _apiServices.put<SingleOrderResponse>(
        url,
            (data) => SingleOrderResponse.fromJson(data),
        data: orderData,
        cancelToken: _cancelToken,
      );

      if (res.success && res.data?.data != null) {
        return ApiResponse.success(res.data!.data!);
      } else {
        return ApiResponse.error(
          res.message,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to update order",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 5. Update Order Status (Specific Helper)
  // Useful for changing status to 'Delivered', 'Cancelled', 'Approved'
  Future<ApiResponse<Order>> updateOrderStatus(int id, String status) async {
    return updateOrder(id, {"status": status});
  }

  // 6. Delete Order
  Future<ApiResponse<bool>> deleteOrder(int id) async {
    try {
      String url = "${ApiConstants.orders}/$id";

      // We use dynamic because delete responses often vary (empty, or just message)
      final res = await _apiServices.delete<dynamic>(
        url,
            (data) => data,
        cancelToken: _cancelToken,
      );

      if (res.success) {
        return ApiResponse.success(true, message: res.message);
      } else {
        return ApiResponse.error(
          res.message,
          statusCode: res.statusCode,
          errors: res.errors,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to delete order",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }
}
