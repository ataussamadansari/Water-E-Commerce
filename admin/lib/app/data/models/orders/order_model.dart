import '../customers/customer_model.dart';
import 'item_model.dart';

class Order {
  Order({
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
    this.customer,
    this.items,});

  Order.fromJson(dynamic json) {
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
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
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
  dynamic deliveryAddress;
  String? scheduledDate;
  dynamic deliveredAt;
  dynamic cancelledAt;
  dynamic rescheduledReason;
  String? notes;
  Customer? customer;
  List<Items>? items;

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
    if (customer != null) {
      map['customer'] = customer?.toJson();
    }
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/*
import '../customers/customer_model.dart';

class Order {
  int? id;
  dynamic orderNo;
  dynamic customerId;
  dynamic salesId;
  dynamic deliveryId;
  dynamic regionId;
  dynamic totalAmount;
  dynamic paidAmount;
  dynamic pendingAmount;
  dynamic status;
  dynamic paymentStatus;
  dynamic deliveryAddress;
  dynamic scheduledDate;
  dynamic deliveredAt;
  dynamic cancelledAt;
  dynamic rescheduledReason;
  dynamic notes;
  Customer? customer;

  Order({
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
    this.customer,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNo: json['order_no'],
      customerId: json['customer_id'],
      salesId: json['sales_id'],
      deliveryId: json['delivery_id'],
      regionId: json['region_id'],
      totalAmount: json['total_amount'],
      paidAmount: json['paid_amount'],
      pendingAmount: json['pending_amount'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      deliveryAddress: json['delivery_address'],
      scheduledDate: json['scheduled_date'],
      deliveredAt: json['delivered_at'],
      cancelledAt: json['cancelled_at'],
      rescheduledReason: json['rescheduled_reason'],
      notes: json['notes'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
    );
  }

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
    if (customer != null) {
      map['customer'] = customer?.toJson();
    }
    return map;
  }
}
*/
