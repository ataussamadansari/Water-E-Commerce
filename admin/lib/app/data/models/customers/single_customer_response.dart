import 'customer_model.dart';

class SingleCustomerResponse {
  SingleCustomerResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  SingleCustomerResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Customer.fromJson(json['data']) : null;
    errors = json['errors'];
  }
  bool? success;
  String? message;
  Customer? data;
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
