
class Items {
  Items({
    this.id,
    this.productId,
    this.qty,
    this.price,
    this.lineTotal,
    this.product,});

  Items.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    qty = json['qty'];
    price = json['price'];
    lineTotal = json['line_total'];
    product = json['product'];
  }
  num? id;
  num? productId;
  num? qty;
  String? price;
  String? lineTotal;
  dynamic product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_id'] = productId;
    map['qty'] = qty;
    map['price'] = price;
    map['line_total'] = lineTotal;
    map['product'] = product;
    return map;
  }

}