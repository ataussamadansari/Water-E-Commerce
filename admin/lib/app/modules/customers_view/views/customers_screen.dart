// lib/app/modules/customers_view/views/customers_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customers_screen_controller.dart';

class CustomersScreen extends GetView<CustomersScreenController> {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          PopupMenuButton<CustomerFilter>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (CustomerFilter result) {
              controller.setFilter(result);
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CustomerFilter>>[
                  const PopupMenuItem<CustomerFilter>(
                    value: CustomerFilter.all,
                    child: Text('All Customers'),
                  ),
                  const PopupMenuItem<CustomerFilter>(
                    value: CustomerFilter.approved,
                    child: Text('Approved Only'),
                  ),
                  const PopupMenuItem<CustomerFilter>(
                    value: CustomerFilter.pending,
                    child: Text('Pending Approval'),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Shop or Mobile...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: controller.search,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.customerService.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredCustomers.isEmpty) {
                return const Center(child: Text("No customers found"));
              }
              return ListView.builder(
                itemCount: controller.filteredCustomers.length,
                itemBuilder: (context, index) {
                  final customer = controller.filteredCustomers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        customer.shopName
                                ?.toString()
                                .substring(0, 1)
                                .toUpperCase() ??
                            "?",
                      ),
                    ),
                    title: Text(
                      customer.shopName?.toString() ?? "Unknown Shop",
                    ),
                    subtitle: Text(
                      "${customer.city ?? ''} • ${customer.mobile ?? ''}",
                    ),
                    trailing: Icon(
                      Icons.circle,
                      color: (customer.isApproved == true)
                          ? Colors.green
                          : Colors.orange,
                      size: 12,
                    ),
                    onTap: () => controller.gotoDetails(customer),
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
