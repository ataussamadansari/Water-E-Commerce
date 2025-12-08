class CartItemRemoveResponse {
  CartItemRemoveResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  CartItemRemoveResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
    errors = json['errors'];
  }
  bool? success;
  String? message;
  dynamic data;
  dynamic errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    map['errors'] = errors;
    return map;
  }

}