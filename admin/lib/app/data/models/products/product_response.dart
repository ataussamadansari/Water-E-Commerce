import 'package:admin/app/data/models/products/product_model.dart';

class ProductResponse {
  ProductResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  ProductResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Product.fromJson(v));
      });
    }
    errors = json['errors'];
  }
  bool? success;
  String? message;
  List<Product>? data;
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

/*
class Data {
  Data({
      this.id,
      this.name,
      this.sku,
      this.description,
      this.imagePath,
      this.price,
      this.minOrderQty,
      this.maxOrderQty,
      this.stockQty,
      this.isActive,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    description = json['description'];
    imagePath = json['image_path'];
    price = json['price'];
    minOrderQty = json['min_order_qty'];
    maxOrderQty = json['max_order_qty'];
    stockQty = json['stock_qty'];
    isActive = json['is_active'];
  }
  num? id;
  String? name;
  String? sku;
  String? description;
  dynamic imagePath;
  String? price;
  String? minOrderQty;
  String? maxOrderQty;
  String? stockQty;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['sku'] = sku;
    map['description'] = description;
    map['image_path'] = imagePath;
    map['price'] = price;
    map['min_order_qty'] = minOrderQty;
    map['max_order_qty'] = maxOrderQty;
    map['stock_qty'] = stockQty;
    map['is_active'] = isActive;
    return map;
  }

}*/
