import 'order_model.dart';

class OrdersResponse {
  OrdersResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  OrdersResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Order.fromJson(v));
      });
    }
    errors = json['errors'];
  }
  bool? success;
  String? message;
  List<Order>? data;
  dynamic errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }

}

