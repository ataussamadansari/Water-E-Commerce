import 'package:admin/app/data/models/api_response_model.dart';
import 'package:admin/app/data/models/customers/customers_response.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/customers/single_customer_response.dart';
import '../../services/api/api_services.dart';

class CustomersRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<CustomersResponse>> getCustomers() async {
    try {
      // We use getList because the 'data' field in your JSON is a List []
      // But since you have a specific ProductResponse wrapper that handles the parsing logic:
      final res = await _apiServices.get<CustomersResponse>(
        ApiConstants.customers,
        (data) => CustomersResponse.fromJson(data),
        cancelToken: _cancelToken,
      );

      if (res.success && res.data?.data != null) {
        // Unwrapping: Return the List<Product> directly in the ApiResponse
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

  Future<ApiResponse<SingleCustomerResponse>> getCustomer(String id) async {
    try {
      final url = ApiConstants.getCustomer.replaceAll("{id}", id);
      final res = await _apiServices.get<SingleCustomerResponse>(
        url,
        (data) => SingleCustomerResponse.fromJson(data),
        cancelToken: _cancelToken,
      );

      if (res.success && res.data?.data != null) {
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

  Future<ApiResponse<SingleCustomerResponse>> updateCustomer(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = ApiConstants.updateCustomer.replaceAll("{id}", id.toString());

      final res = await _apiServices.put<SingleCustomerResponse>(
        url,
        (data) => SingleCustomerResponse.fromJson(data),
        data: data,
        cancelToken: _cancelToken,
      );

      if (res.success && res.data?.data != null) {
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
