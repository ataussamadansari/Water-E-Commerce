import 'product_model.dart';

class SingleProductResponse {
  bool? success;
  String? message;
  Product? data;
  dynamic errors;

  SingleProductResponse({this.success, this.message, this.data, this.errors});

  SingleProductResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Product.fromJson(json['data']) : null;
    errors = json['errors'];
  }
}
