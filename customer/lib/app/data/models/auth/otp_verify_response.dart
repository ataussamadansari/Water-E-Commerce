class OtpVerifyResponse {
  OtpVerifyResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  OtpVerifyResponse.fromJson(dynamic json) {
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
      this.user, 
      this.roles, 
      this.accessToken,});

  Data.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    accessToken = json['access_token'];
  }
  User? user;
  List<String>? roles;
  String? accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['roles'] = roles;
    map['access_token'] = accessToken;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.name, 
      this.mobile, 
      this.email, 
      this.fcmToken, 
      this.isActive,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
  }
  num? id;
  String? name;
  String? mobile;
  dynamic email;
  dynamic fcmToken;
  bool? isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['mobile'] = mobile;
    map['email'] = email;
    map['fcm_token'] = fcmToken;
    map['is_active'] = isActive;
    return map;
  }

}