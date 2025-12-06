import 'package:admin/app/core/utils/DateTimeHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/orders/order_model.dart';
import '../controllers/orders_screen_controller.dart';

class OrdersScreen extends GetView<OrdersScreenController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        actions: [
          // Filter Button
          Obx(() => PopupMenuButton<OrderFilter>(
            icon: Icon(Icons.filter_list,
                color: controller.currentFilter.value != OrderFilter.all
                    ? Get.theme.primaryColor
                    : null
            ),
            onSelected: controller.setFilter,
            itemBuilder: (context) => [
              const PopupMenuItem(value: OrderFilter.all, child: Text("All Orders")),
              const PopupMenuItem(value: OrderFilter.pending, child: Text("Pending")),
              const PopupMenuItem(value: OrderFilter.approved, child: Text("Approved")),
              const PopupMenuItem(value: OrderFilter.delivered, child: Text("Delivered")),
              const PopupMenuItem(value: OrderFilter.cancelled, child: Text("Cancelled")),
            ],
          )),
        ],
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Order ID, No, or Shop Name...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.05),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: controller.search,
            ),
          ),

          // --- Filter Chips (Optional Visual Indicator) ---
          Obx(() {
            if (controller.currentFilter.value == OrderFilter.all) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(controller.currentFilter.value.name.capitalizeFirst!),
                onDeleted: () => controller.setFilter(OrderFilter.all),
                backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: Get.theme.primaryColor),
                deleteIconColor: Get.theme.primaryColor,
              ),
            );
          }),

          // --- Orders List ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.filteredOrders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredOrders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text("No orders found", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshOrders,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return _buildOrderCard(context, order);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = _getStatusColor(order.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.gotoOrderDetails(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "#${order.orderNo ?? order.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status?.toUpperCase() ?? "UNKNOWN",
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Customer Details
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.store, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customer?.shopName ?? "Unknown Shop",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (order.scheduledDate != null)
                          Text(
                            "Date: ${DateTimeHelper.formatFull(order.scheduledDate!)}", // Format using DateFormat if needed
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${order.totalAmount ?? '0.00'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "${order.items?.length ?? 0} Items",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.blue;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
