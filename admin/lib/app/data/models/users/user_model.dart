class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  bool? isActive;
  String? role;

  User({this.id, this.name, this.email, this.mobile, this.isActive, this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    isActive = json['is_active'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['is_active'] = isActive;
    data['role'] = role;
    return data;
  }
}
