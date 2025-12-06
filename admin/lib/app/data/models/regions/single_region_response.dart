import 'package:admin/app/data/models/regions/region_model.dart';

class SingleRegionResponse {
  bool? success;
  String? message;
  Region? data;
  dynamic errors;

  SingleRegionResponse({this.success, this.message, this.data, this.errors});

  factory SingleRegionResponse.fromJson(Map<String, dynamic> json) {
    return SingleRegionResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? Region.fromJson(json['data']) : null,
      errors: json['errors'],
    );
  }
}
