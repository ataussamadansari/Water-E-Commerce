import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/api_response_model.dart';
import '../../models/products/product_model.dart';
import '../../models/products/products_response.dart';
import '../../services/api/api_services.dart';

class ProductsRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<ProductsResponse>> getProducts() async {
    try {
      final res = await _apiServices.get<ProductsResponse>(
        ApiConstants.products,
            (data) => ProductsResponse.fromJson(data),
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

  Future<ApiResponse<ProductModel>> getProductById(num id) async {
    try {
      final url = "${ApiConstants.products}/$id";
      final res = await _apiServices.get<ProductModel>(
        url,
            (data) => ProductModel.fromJson(data),
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

  void cancelRequests() {
    _cancelToken?.cancel();
    _cancelToken = CancelToken();
  }
}
