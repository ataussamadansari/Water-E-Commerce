import 'package:admin/app/core/utils/DateTimeHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_ledger_screen_controller.dart';

class CustomerLedgerScreen extends GetView<CustomerLedgerScreenController> {
  const CustomerLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.customer.shopName ?? 'Customer Ledger'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.ledgerEntries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  "No ledger entries found.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshLedger,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.ledgerEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = controller.ledgerEntries[index];
              final isCredit = entry.type.toLowerCase() == 'credit';
              final amountColor = isCredit ? Colors.green : Colors.red;
              
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              entry.description,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          Text(
                            "${isCredit ? '+' : '-'} ₹${entry.amount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: amountColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateTimeHelper.formatDateMonth(entry.date.toString()),
                            // DateFormat('dd MMM yyyy').format(entry.date),
                             style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "Balance: ₹${entry.balance.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
