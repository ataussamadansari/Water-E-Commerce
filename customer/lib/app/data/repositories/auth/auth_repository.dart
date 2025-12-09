import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/constants/api_constants.dart';
import '../../models/api_response_model.dart';
import '../../models/auth/otp_verify_response.dart';
import '../../models/auth/send_otp_response.dart';
import '../../services/api/api_services.dart';

class AuthRepository {
  final ApiServices _apiServices = ApiServices();
  CancelToken? _cancelToken;

  Future<ApiResponse<SendOtpResponse>> sendOtp(String mobile) async {
    try {
      final res = await _apiServices.post<SendOtpResponse>(
        ApiConstants.sendOtp,
        (data) => SendOtpResponse.fromJson(data),
        data: {"mobile": mobile},
        cancelToken: _cancelToken,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!, message: res.data!.message);
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

  Future<ApiResponse<OtpVerifyResponse>> verifyOtp(String mobile, String otpCode, String roleHint) async {
    try {
      final res = await _apiServices.post<OtpVerifyResponse>(
        ApiConstants.verifyOtp,
            (data) => OtpVerifyResponse.fromJson(data),
        data: {
          "mobile": mobile,
          "otp_code": otpCode,
          "role_hint": roleHint
        },
        cancelToken: _cancelToken,
      );
      if (res.success && res.data != null) {
        return ApiResponse.success(res.data!, message: res.data!.message);
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

