import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../services/api/api_services.dart';
import '../../models/api_response_model.dart';
import '../../models/users/user_model.dart';
import '../../models/users/user_response.dart';
import '../../models/users/single_user_response.dart';

class UserRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  // 1. Get All Users (Optional role filter)
  Future<ApiResponse<UserResponse>> getUsers({String? role}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }

      final res = await _apiServices.get<UserResponse>(
        ApiConstants.users,
            (data) => UserResponse.fromJson(data),
        queryParameters: queryParams,
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

  // 2. Create User
  Future<ApiResponse<User>> createUser(Map<String, dynamic> userData) async {
    try {
      final res = await _apiServices.post<SingleUserResponse>(
        ApiConstants.createUser,
            (data) => SingleUserResponse.fromJson(data),
        data: userData,
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
        e.message ?? "Failed to create user",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 3. Get User By ID
  Future<ApiResponse<User>> getUserById(int id) async {
    try {
      String url = ApiConstants.getUser.replaceAll('{id}', id.toString());

      final res = await _apiServices.get<SingleUserResponse>(
        url,
            (data) => SingleUserResponse.fromJson(data),
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
        e.message ?? "Failed to fetch user",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 4. Update User
  Future<ApiResponse<User>> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      String url = ApiConstants.updateUser.replaceAll('{id}', id.toString());

      final res = await _apiServices.put<SingleUserResponse>(
        url,
            (data) => SingleUserResponse.fromJson(data),
        data: userData,
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
        e.message ?? "Failed to update user",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }

  // 5. Delete User
  Future<ApiResponse<bool>> deleteUser(int id) async {
    try {
      String url = ApiConstants.deleteUser.replaceAll('{id}', id.toString());

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
        e.message ?? "Failed to delete user",
        statusCode: e.response?.statusCode,
        errors: e.response?.data,
      );
    }
  }
}
