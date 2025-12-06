import 'package:admin/app/data/models/api_response_model.dart';
import 'package:admin/app/data/models/regions/regions_response.dart';
import 'package:admin/app/data/models/regions/single_region_response.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../services/api/api_services.dart';

class RegionRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  // --- GET ALL REGIONS ---
  Future<ApiResponse<RegionsResponse>> getRegions() async {
    try {
      final res = await _apiServices.get(
        ApiConstants.regions, // Endpoint: /admin/regions (GET)
            (data) => RegionsResponse.fromJson(data),
        cancelToken: _cancelToken
      );
      return res;
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to fetch regions",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  Future<ApiResponse<SingleRegionResponse>> createRegion(
      Map<String, dynamic> regionData) async {
    try {
      final res = await _apiServices.post<SingleRegionResponse>(
        ApiConstants.createRegions, // Endpoint: /admin/regions
            (data) => SingleRegionResponse.fromJson(data),
        data: regionData,
          cancelToken: _cancelToken
      );

      return res;
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to create region",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 2. GET REGION BY ID
  Future<ApiResponse<SingleRegionResponse>> getRegionById(int regionId) async {
    try {
      String url = ApiConstants.getRegion.replaceAll('{id}', regionId.toString());
      final res = await _apiServices.get<SingleRegionResponse>(
        url,
            (data) => SingleRegionResponse.fromJson(data), // Assuming data is nested
          cancelToken: _cancelToken
      );
      return res;
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to fetch region details",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // 3. UPDATE REGION
  Future<ApiResponse<SingleRegionResponse>> updateRegion(
      int regionId, Map<String, dynamic> regionData) async {
    try {
      String url = ApiConstants.updateRegion.replaceAll('{id}', regionId.toString());
      // The API for updates typically uses the PUT method
      final res = await _apiServices.put<SingleRegionResponse>(
        url,
            (data) => SingleRegionResponse.fromJson(data), // Assuming data is nested
        data: regionData,
      );
      return res;
    } on DioException catch (e) {
      return ApiResponse.error(
        e.message ?? "Failed to update region",
        statusCode: e.response?.statusCode,
      );
    }
  }

  // --- DELETE REGION ---
  Future<ApiResponse<bool>> deleteRegion(int regionId) async {
    try {
      String url = ApiConstants.deleteRegion.replaceAll('{id}', regionId.toString());

      // Using generic 'dynamic' since delete usually returns a success message/status
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
        e.message ?? "Failed to delete region",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }
}
