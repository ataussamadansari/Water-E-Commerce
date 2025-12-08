import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/api_response_model.dart';
import '../../models/ledger/ledger_response.dart';
import '../../services/api/api_services.dart';

class LedgerRepository {
  final ApiServices _apiServices = ApiServices();

  Future<ApiResponse<LedgerResponse>> getLedger() async {
    try {
      final res = await _apiServices.get<LedgerResponse>(
        ApiConstants.ledger,
        (json) => LedgerResponse.fromJson(json),
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
