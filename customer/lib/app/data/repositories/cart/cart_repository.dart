import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/api_response_model.dart';
import '../../models/cart/carts_response.dart';
import '../../models/cart/cart_item_remove_response.dart';
import '../../services/api/api_services.dart';

class CartRepository {
  final ApiServices _apiServices = ApiServices();

  Future<ApiResponse<CartsResponse>> getCart() async {
    try {
      final res = await _apiServices.get<CartsResponse>(
        ApiConstants.cart,
        (json) => CartsResponse.fromJson(json),
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

  Future<ApiResponse<CartsResponse>> addToCart(Map<String, dynamic> data) async {
    try {
      final res = await _apiServices.post<CartsResponse>(
        ApiConstants.addCart,
        (json) => CartsResponse.fromJson(json),
        data: data,
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

  Future<ApiResponse<CartItemRemoveResponse>> removeFromCart(int cartItemId) async {
    try {
      // Endpoint is /customer/cart/{cartItem}/delete
      // We need to replace {cartItem} with the actual ID.
      final url = ApiConstants.removeItem.replaceAll("{cartItem}", cartItemId.toString());

      final res = await _apiServices.post<CartItemRemoveResponse>(
        url,
        (json) => CartItemRemoveResponse.fromJson(json),
        // Typically DELETE or POST for deletion might not need body if ID is in URL, 
        // but if it's POST without body, just pass empty or null.
      );

      if (res.success) {
        return ApiResponse.success(res.data!); // assuming res.data is not null or handled
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

  Future<ApiResponse<CartsResponse>> clearCart() async {
    try {
      final res = await _apiServices.post<CartsResponse>(
        ApiConstants.clearCart,
        (json) => CartsResponse.fromJson(json),
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

  Future<ApiResponse<dynamic>> checkout(Map<String, dynamic> data) async {
    try {
      final res = await _apiServices.post<dynamic>(
        ApiConstants.checkout,
        (json) => json, 
        data: data,
      );

      if (res.success) {
        return ApiResponse.success(res.data);
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
}
