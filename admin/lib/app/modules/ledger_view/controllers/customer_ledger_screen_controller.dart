import 'package:get/get.dart';
import '../../../data/models/customers/customer_model.dart';
import '../../../data/models/ledger/ledger_response.dart';
import '../../../data/services/ledger/ledger_service.dart';

class LedgerEntry {
  final String type;
  final String description;
  final num amount;
  final DateTime date;
  num balance;

  LedgerEntry({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.balance = 0,
  });
}

class CustomerLedgerScreenController extends GetxController {
  final LedgerService _ledgerService = Get.put(LedgerService());

  late Customer customer;

  bool get isLoading => _ledgerService.isLoading.value;
  final RxList<LedgerEntry> ledgerEntries = <LedgerEntry>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Customer) {
      customer = Get.arguments;
      _ledgerService.fetchLedger(customer.id!);
      ever(_ledgerService.ledgerData, _updateLedgerEntries);
    } else {
      Get.back();
    }
  }

  void _updateLedgerEntries(LedgerData? data) {
    if (data == null) {
      ledgerEntries.clear();
      return;
    }

    final combined = <LedgerEntry>[];
    if (data.orders != null) {
      for (final order in data.orders!) {
        final date = order.scheduledDate != null ? DateTime.tryParse(order.scheduledDate!) : null;
        if (date == null) continue;
        combined.add(LedgerEntry(
          type: 'debit',
          description: 'Order #${order.orderNo ?? ''}',
          amount: num.tryParse(order.totalAmount ?? '0') ?? 0,
          date: date,
        ));
      }
    }

    if (data.payments != null) {
      for (final payment in data.payments!) {
        final date = payment.date != null ? DateTime.tryParse(payment.date!) : null;
        if (date == null) continue;
        combined.add(LedgerEntry(
          type: 'credit',
          description: 'Payment (${payment.method ?? 'N/A'})',
          amount: num.tryParse(payment.amount ?? '0') ?? 0,
          date: date,
        ));
      }
    }

    // Sort by date, oldest first to calculate balance
    combined.sort((a, b) => a.date.compareTo(b.date));

    num totalOrders = data.orders?.fold(0, (sum, order) => sum! + (num.tryParse(order.totalAmount ?? '0') ?? 0)) ?? 0;
    num totalPayments = data.payments?.fold(0, (sum, p) => sum! + (num.tryParse(p.amount ?? '0') ?? 0)) ?? 0;
    num openingBalance = (data.totalPendingAmount ?? 0) - totalOrders + totalPayments;

    num runningBalance = openingBalance;
    for (var entry in combined) {
      if (entry.type == 'debit') {
        runningBalance += entry.amount;
      } else {
        runningBalance -= entry.amount;
      }
      entry.balance = runningBalance;
    }

    // Display newest first.
    ledgerEntries.value = combined.reversed.toList();
  }

  Future<void> refreshLedger() async {
    await _ledgerService.fetchLedger(customer.id!);
  }
}
