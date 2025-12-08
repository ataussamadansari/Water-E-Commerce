class ProfileResponse {
  ProfileResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  ProfileResponse.fromJson(dynamic json) {
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
      this.userId, 
      this.mobile, 
      this.shopName, 
      this.shopPhotoPath, 
      this.addressLine, 
      this.city, 
      this.state, 
      this.pincode, 
      this.gpsLat, 
      this.gpsLng, 
      this.salesId, 
      this.creditLimit, 
      this.isApproved,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    mobile = json['mobile'];
    shopName = json['shop_name'];
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
  num? id;
  num? userId;
  String? mobile;
  String? shopName;
  dynamic shopPhotoPath;
  String? addressLine;
  String? city;
  String? state;
  String? pincode;
  num? gpsLat;
  num? gpsLng;
  dynamic salesId;
  String? creditLimit;
  bool? isApproved;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['mobile'] = mobile;
    map['shop_name'] = shopName;
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