import 'order_model.dart';

class OrderPlaceResponse {
  OrderPlaceResponse({
    this.success,
    this.message,
    this.data,
    this.errors,});

  OrderPlaceResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    // Uses reusable OrderData (Single object here, not a list)
    data = json['data'] != null ? OrderData.fromJson(json['data']) : null;
    errors = json['errors'];
  }

  bool? success;
  String? message;
  OrderData? data; // Single OrderData
  dynamic errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['errors'] = errors;
    return map;
  }
}
