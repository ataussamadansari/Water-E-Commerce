import 'user_model.dart';

class SingleUserResponse {
  bool? success;
  String? message;
  User? data;
  dynamic errors;

  SingleUserResponse({this.success, this.message, this.data, this.errors});

  SingleUserResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? User.fromJson(json['data']) : null;
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
