import 'package:customer/app/data/models/order/order_place_response.dart';
import 'package:customer/app/data/models/order/orders_response.dart';
import 'package:customer/app/data/models/order/single_order_response.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/api_response_model.dart';
import '../../services/api/api_services.dart';

class OrderRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<OrderPlaceResponse>> orderPlace(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _apiServices.post<OrderPlaceResponse>(
        ApiConstants.orderPlace,
        (json) => OrderPlaceResponse.fromJson(json),
        data: data,
        cancelToken: _cancelToken,
      );

      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!, message: res.message);
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

  Future<ApiResponse<OrdersResponse>> getOrders() async {
    try {
      final res = await _apiServices.get<OrdersResponse>(
        ApiConstants.orders, // Corrected endpoint
        (data) => OrdersResponse.fromJson(data),
        cancelToken: _cancelToken,
      );

      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!, message: res.message);
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

  Future<ApiResponse<SingleOrderResponse>> getOrderById(int id) async {
    try {
      // Correctly construct URL using ID replacement if needed, but here simple append
      // ApiConstants.getOrder is "/customer/orders/{id}"
      // We should probably just construct it manually or replace {id}
      final url = ApiConstants.getOrder.replaceAll("{id}", id.toString());
      
      final res = await _apiServices.get<SingleOrderResponse>(
        url,
        (data) => SingleOrderResponse.fromJson(data),
        cancelToken: _cancelToken,
      );

      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!, message: res.message);
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

  void cancelRequests() {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
  }
}
