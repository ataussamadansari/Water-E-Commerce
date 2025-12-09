import 'package:customer/app/core/utils/DateTimeHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_screen_controller.dart';
import '../../../routes/app_routes.dart';

class OrdersScreen extends GetView<OrdersScreenController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: controller.filterOptions.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() => ChoiceChip(
                    label: Text(filter),
                    selected: controller.selectedFilter.value == filter,
                    onSelected: (selected) {
                      if (selected) {
                        controller.setFilter(filter);
                      }
                    },
                  )),
                );
              }).toList(),
            ),
          ),
          
          // Orders List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
        
              if (controller.isError.value) {
                 return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(controller.hasError.value),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: controller.refreshOrders,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                );
              }
        
              if (controller.filteredOrders.isEmpty) {
                return const Center(child: Text("No orders found."));
              }
        
              return RefreshIndicator(
                onRefresh: controller.refreshOrders,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        onTap: () {
                           Get.toNamed(Routes.orderDetails, arguments: order.id);
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(Icons.shopping_bag, color: Colors.blue.shade700),
                        ),
                        title: Text(
                          "#${order.orderNo ?? order.id}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Scheduled: ${order.scheduledDate != null ? DateTimeHelper.formatDateMonth(order.scheduledDate!) : 'N/A'}"),
                            const SizedBox(height: 2),
                            Text(
                              "Total: ₹${order.totalAmount ?? '0'}",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status ?? '').withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.status ?? 'Pending',
                            style: TextStyle(
                              color: _getStatusColor(order.status ?? ''),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
