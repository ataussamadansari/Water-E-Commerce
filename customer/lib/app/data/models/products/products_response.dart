import 'product_model.dart';

class ProductsResponse {
  ProductsResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  ProductsResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductModel.fromJson(v));
      });
    }
    errors = json['errors'];
  }
  bool? success;
  String? message;
  List<ProductModel>? data;
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
