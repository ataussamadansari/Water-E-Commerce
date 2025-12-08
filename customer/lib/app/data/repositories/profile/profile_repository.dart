import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/api_response_model.dart';
import '../../models/profile/profile_response.dart';
import '../../services/api/api_services.dart';

class ProfileRepository {
  final ApiServices _apiServices = ApiServices();

  Future<ApiResponse<ProfileResponse>> getProfile() async {
    try {
      final res = await _apiServices.get<ProfileResponse>(
        ApiConstants.profile,
        (json) => ProfileResponse.fromJson(json),
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

  Future<ApiResponse<ProfileResponse>> updateProfile(dynamic data) async {
    try {
      // Data can be Map<String, dynamic> or FormData
      final res = await _apiServices.post<ProfileResponse>( // Changed to post if server expects POST for updates including files, otherwise keep PUT and ensure ApiProvider handles FormData
        ApiConstants.updateProfile, // Verify if this endpoint accepts PUT or POST for file upload. Usually POST is safer for multipart.
        (json) => ProfileResponse.fromJson(json),
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
}
