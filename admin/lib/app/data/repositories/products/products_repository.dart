import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../services/api/api_services.dart';
import '../../models/api_response_model.dart';
import '../../models/products/product_model.dart'; // Your shared model
import '../../models/products/product_response.dart'; // List response
import '../../models/products/single_product_response.dart';

class ProductRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  // 1. Get All Products
  Future<ApiResponse<ProductResponse>> getProducts() async {
    try {
      // We use getList because the 'data' field in your JSON is a List []
      // But since you have a specific ProductResponse wrapper that handles the parsing logic:
      final res = await _apiServices.get<ProductResponse>(
        ApiConstants.products,
            (data) => ProductResponse.fromJson(data),
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

  // 2. Create Product
  Future<ApiResponse<Product>> createProduct(Map<String, dynamic> productData) async {
    try {
      final res = await _apiServices.post<SingleProductResponse>(
        ApiConstants.createProduct,
            (data) => SingleProductResponse.fromJson(data),
        data: productData,
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
        e.message ?? "Failed to create product",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 3. Get Product By ID
  Future<ApiResponse<Product>> getProductById(int id) async {
    try {
      // Replace {id} in the URL
      String url = ApiConstants.getProduct.replaceAll('{id}', id.toString());

      final res = await _apiServices.get<SingleProductResponse>(
        url,
            (data) => SingleProductResponse.fromJson(data),
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
        e.message ?? "Failed to fetch product",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 4. Update Product
  Future<ApiResponse<Product>> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      // Replace {id} in the URL
      String url = ApiConstants.updateProduct.replaceAll('{id}', id.toString());

      // Usually updates use PUT or PATCH
      final res = await _apiServices.put<SingleProductResponse>(
        url,
            (data) => SingleProductResponse.fromJson(data),
        data: productData,
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
        e.message ?? "Failed to update product",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 5. Delete Product
  Future<ApiResponse<bool>> deleteProduct(int id) async {
    try {
      String url = ApiConstants.deleteProduct.replaceAll('{id}', id.toString());

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
        e.message ?? "Failed to delete product",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }
}
