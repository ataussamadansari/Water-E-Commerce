class Payment {
  int? id;
  String? date;
  String? amount;
  String? method; // e.g., 'cash', 'online'
  String? notes;

  Payment({this.id, this.date, this.amount, this.method, this.notes});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    amount = json['amount'];
    method = json['method'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['amount'] = amount;
    data['method'] = method;
    data['notes'] = notes;
    return data;
  }
}
