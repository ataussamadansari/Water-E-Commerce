import '../order/order_model.dart';

class LedgerResponse {
  LedgerResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  LedgerResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? LedgerData.fromJson(json['data']) : null;
    errors = json['errors'];
  }
  bool? success;
  String? message;
  LedgerData? data;
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

class LedgerData {
  LedgerData({
      this.totalOrderAmount, 
      this.totalPaidAmount, 
      this.totalPendingAmount, 
      this.orders, 
      this.payments,});

  LedgerData.fromJson(dynamic json) {
    totalOrderAmount = json['total_order_amount'];
    totalPaidAmount = json['total_paid_amount'];
    totalPendingAmount = json['total_pending_amount'];
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(OrderData.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      payments = [];
      json['payments'].forEach((v) {
        payments?.add(Payment.fromJson(v));
      });
    }
  }
  num? totalOrderAmount;
  num? totalPaidAmount;
  num? totalPendingAmount;
  List<OrderData>? orders;
  List<Payment>? payments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_order_amount'] = totalOrderAmount;
    map['total_paid_amount'] = totalPaidAmount;
    map['total_pending_amount'] = totalPendingAmount;
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    if (payments != null) {
      map['payments'] = payments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Payment {
  Payment({
      this.id,
      this.amount,
      this.paymentDate,
      this.method,
      this.notes,
  });

  Payment.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    paymentDate = json['payment_date'];
    method = json['method'];
    notes = json['notes'];
  }

  num? id;
  String? amount;
  String? paymentDate;
  String? method;
  String? notes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['payment_date'] = paymentDate;
    map['method'] = method;
    map['notes'] = notes;
    return map;
  }
}
