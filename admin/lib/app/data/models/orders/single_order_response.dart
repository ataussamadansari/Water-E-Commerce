import 'order_model.dart';

class SingleOrderResponse {
  SingleOrderResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  SingleOrderResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Order.fromJson(json['data']) : null;
    errors = json['errors'];
  }
  bool? success;
  String? message;
  Order? data;
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

