import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ledger_screen_controller.dart';

class LedgerScreen extends GetView<LedgerScreenController> {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Ledgers"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchCustomers,
              decoration: InputDecoration(
                hintText: "Search customer by name or mobile...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          // Customer List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredCustomers.isEmpty) {
                return const Center(child: Text("No customers found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = controller.filteredCustomers[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      onTap: () => controller.gotoCustomerLedger(customer),
                      title: Text(customer.shopName ?? "Unknown"),
                      subtitle: Text("ID: ${customer.id} | Mobile: ${customer.mobile}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
