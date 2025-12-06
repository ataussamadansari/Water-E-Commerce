/// Common Order Data Model
class OrderData {
  OrderData({
    this.id,
    this.orderNo,
    this.customerId,
    this.salesId,
    this.deliveryId,
    this.regionId,
    this.totalAmount,
    this.paidAmount,
    this.pendingAmount,
    this.status,
    this.paymentStatus,
    this.deliveryAddress,
    this.scheduledDate,
    this.deliveredAt,
    this.cancelledAt,
    this.rescheduledReason,
    this.notes,
    this.items,
  });

  OrderData.fromJson(dynamic json) {
    id = json['id'];
    orderNo = json['order_no'];
    customerId = json['customer_id'];
    salesId = json['sales_id'];
    deliveryId = json['delivery_id'];
    regionId = json['region_id'];
    totalAmount = json['total_amount'];
    paidAmount = json['paid_amount'];
    pendingAmount = json['pending_amount'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    deliveryAddress = json['delivery_address'];
    scheduledDate = json['scheduled_date'];
    deliveredAt = json['delivered_at'];
    cancelledAt = json['cancelled_at'];
    rescheduledReason = json['rescheduled_reason'];
    notes = json['notes'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(OrderItem.fromJson(v));
      });
    }
  }

  num? id;
  String? orderNo;
  num? customerId;
  dynamic salesId;
  dynamic deliveryId;
  dynamic regionId;
  String? totalAmount;
  String? paidAmount;
  String? pendingAmount;
  String? status;
  String? paymentStatus;
  String? deliveryAddress;
  String? scheduledDate;
  dynamic deliveredAt;
  dynamic cancelledAt;
  dynamic rescheduledReason;
  String? notes; // Changed to String? to match common usage
  List<OrderItem>? items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['order_no'] = orderNo;
    map['customer_id'] = customerId;
    map['sales_id'] = salesId;
    map['delivery_id'] = deliveryId;
    map['region_id'] = regionId;
    map['total_amount'] = totalAmount;
    map['paid_amount'] = paidAmount;
    map['pending_amount'] = pendingAmount;
    map['status'] = status;
    map['payment_status'] = paymentStatus;
    map['delivery_address'] = deliveryAddress;
    map['scheduled_date'] = scheduledDate;
    map['delivered_at'] = deliveredAt;
    map['cancelled_at'] = cancelledAt;
    map['rescheduled_reason'] = rescheduledReason;
    map['notes'] = notes;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// Common Order Item Model
class OrderItem {
  OrderItem({
    this.id,
    this.productId,
    this.qty,
    this.price,
    this.lineTotal,
    this.product,
  });

  OrderItem.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    qty = json['qty'];
    price = json['price'];
    lineTotal = json['line_total'];
    product = json['product'] != null ? OrderProduct.fromJson(json['product']) : null;
  }

  num? id;
  num? productId;
  num? qty;
  String? price;
  String? lineTotal;
  OrderProduct? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_id'] = productId;
    map['qty'] = qty;
    map['price'] = price;
    map['line_total'] = lineTotal;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }
}

/// Common Product Model (Specific to Orders)
class OrderProduct {
  OrderProduct({
    this.id,
    this.name,
    this.sku,
    this.description,
    this.imagePath,
    this.price,
    this.minOrderQty,
    this.maxOrderQty,
    this.stockQty,
    this.isActive,
  });

  OrderProduct.fromJson(dynamic json) {
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
