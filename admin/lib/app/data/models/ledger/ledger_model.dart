class LedgerEntry {
  int? id;
  String? date;
  String? type; // 'credit', 'debit'
  double? amount;
  String? description;
  String? referenceId; // order_id etc.
  double? balance;

  LedgerEntry({
    this.id,
    this.date,
    this.type,
    this.amount,
    this.description,
    this.referenceId,
    this.balance,
  });

  LedgerEntry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    type = json['type'];
    amount = double.tryParse(json['amount']?.toString() ?? '0');
    description = json['description'];
    referenceId = json['reference_id'];
    balance = double.tryParse(json['balance']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['type'] = type;
    data['amount'] = amount;
    data['description'] = description;
    data['reference_id'] = referenceId;
    data['balance'] = balance;
    return data;
  }
}
