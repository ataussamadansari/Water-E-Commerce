class Region {
  int? id;
  String? name;
  String? city;
  String? state;
  bool? isActive;

  Region({
    this.id,
    this.name,
    this.city,
    this.state,
    this.isActive,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      state: json['state'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['city'] = city;
    data['state'] = state;
    data['is_active'] = isActive;
    return data;
  }
}
