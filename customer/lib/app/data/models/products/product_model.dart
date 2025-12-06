class ProductModel {
  ProductModel({
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

  ProductModel.fromJson(dynamic json) {
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
  dynamic id;
  dynamic name;
  dynamic sku;
  dynamic description;
  dynamic imagePath;
  dynamic price;
  dynamic minOrderQty;
  dynamic maxOrderQty;
  dynamic stockQty;
  dynamic isActive;

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