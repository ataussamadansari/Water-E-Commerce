import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/orders_screen_controller.dart';
import 'widgets/order_card.dart';

class OrdersScreen extends GetView<OrdersScreenController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Orders"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            onPressed: controller.refreshOrders, 
            icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: "Search order no, customer...",
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

          // 2. Filter Chips
          SizedBox(
            height: 40,
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip("All", OrderFilter.all),
                  const SizedBox(width: 8),
                  _buildFilterChip("Created", OrderFilter.created),
                  const SizedBox(width: 8),
                  _buildFilterChip("Assigned", OrderFilter.assigned),
                  const SizedBox(width: 8),
                  _buildFilterChip("Delivered", OrderFilter.delivered),
                  const SizedBox(width: 8),
                  _buildFilterChip("Cancelled", OrderFilter.cancelled),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 3. Orders List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredOrders.isEmpty) {
                return const Center(
                  child: Text("No orders found matching your criteria."),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshOrders,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final order = controller.filteredOrders[index];
                    return GestureDetector(
                      onTap: () => controller.showAssignDeliverySheet(order),
                      child: OrderCard(order: order),
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

  Widget _buildFilterChip(String label, OrderFilter filter) {
    final isSelected = controller.currentFilter.value == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.setFilter(filter);
      },
      selectedColor: Get.theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
