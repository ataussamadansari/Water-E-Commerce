import 'package:admin/app/data/models/regions/region_model.dart';

class RegionsResponse {
  RegionsResponse({
      this.success, 
      this.message, 
      this.data, 
      this.errors,});

  RegionsResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Region.fromJson(v));
      });
    }
    errors = json['errors'];
  }
  bool? success;
  String? message;
  List<Region>? data;
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
