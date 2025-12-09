class UsersResponse {
  UsersResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  UsersResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    errors = json['errors'];
  }
  bool? success;
  String? message;
  List<Data>? data;
  dynamic errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }

}

class Data {
  Data({
      this.id, 
      this.name, 
      this.mobile, 
      this.email, 
      this.fcmToken, 
      this.isActive, 
      this.roles,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    fcmToken = json['fcm_token'];
    isActive = json['is_active'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
  }
  num? id;
  String? name;
  String? mobile;
  String? email;
  dynamic fcmToken;
  bool? isActive;
  List<String>? roles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['mobile'] = mobile;
    map['email'] = email;
    map['fcm_token'] = fcmToken;
    map['is_active'] = isActive;
    map['roles'] = roles;
    return map;
  }

}