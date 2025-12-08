class AddCartResponse {
  AddCartResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  AddCartResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'];
  }
  bool? success;
  String? message;
  Data? data;
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

class Data {
  Data({
      this.id, 
      this.productId, 
      this.qty, 
      this.product,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    qty = json['qty'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  num? id;
  num? productId;
  num? qty;
  Product? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_id'] = productId;
    map['qty'] = qty;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }

}

class Product {
  Product({
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

  Product.fromJson(dynamic json) {
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
  num? minOrderQty;
  num? maxOrderQty;
  num? stockQty;
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

}