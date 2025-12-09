import 'payment_model.dart';
import '../orders/order_model.dart';

class LedgerResponse {
  bool? success;
  String? message;
  LedgerData? data;
  dynamic errors;

  LedgerResponse({this.success, this.message, this.data, this.errors});

  LedgerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? LedgerData.fromJson(json['data']) : null;
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errors'] = errors;
    return data;
  }
}

class LedgerData {
  num? totalOrderAmount;
  num? totalPaidAmount;
  num? totalPendingAmount;
  List<Order>? orders;
  List<Payment>? payments;

  LedgerData({
    this.totalOrderAmount,
    this.totalPaidAmount,
    this.totalPendingAmount,
    this.orders,
    this.payments,
  });

  LedgerData.fromJson(Map<String, dynamic> json) {
    totalOrderAmount = json['total_order_amount'];
    totalPaidAmount = json['total_paid_amount'];
    totalPendingAmount = json['total_pending_amount'];
    
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromJson(v));
      });
    }
    
    if (json['payments'] != null) {
      payments = <Payment>[];
      json['payments'].forEach((v) {
        payments!.add(Payment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_order_amount'] = totalOrderAmount;
    data['total_paid_amount'] = totalPaidAmount;
    data['total_pending_amount'] = totalPendingAmount;
    
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
