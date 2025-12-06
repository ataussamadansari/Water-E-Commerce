class Customer {
  Customer({
    this.id,
    this.userId,
    this.shopName,
    this.mobile,
    this.shopPhotoPath,
    this.addressLine,
    this.city,
    this.state,
    this.pincode,
    this.gpsLat,
    this.gpsLng,
    this.salesId,
    this.creditLimit,
    this.isApproved,
  });

  Customer.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    shopName = json['shop_name'];
    mobile = json['mobile'];
    shopPhotoPath = json['shop_photo_path'];
    addressLine = json['address_line'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    gpsLat = json['gps_lat'];
    gpsLng = json['gps_lng'];
    salesId = json['sales_id'];
    creditLimit = json['credit_limit'];
    isApproved = json['is_approved'];
  }

  int? id;
  dynamic userId;
  dynamic shopName;
  dynamic mobile;
  dynamic shopPhotoPath;
  dynamic addressLine;
  dynamic city;
  dynamic state;
  dynamic pincode;
  dynamic gpsLat;
  dynamic gpsLng;
  dynamic salesId;
  dynamic creditLimit;
  bool? isApproved;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['shop_name'] = shopName;
    map['mobile'] = mobile;
    map['shop_photo_path'] = shopPhotoPath;
    map['address_line'] = addressLine;
    map['city'] = city;
    map['state'] = state;
    map['pincode'] = pincode;
    map['gps_lat'] = gpsLat;
    map['gps_lng'] = gpsLng;
    map['sales_id'] = salesId;
    map['credit_limit'] = creditLimit;
    map['is_approved'] = isApproved;
    return map;
  }
}
