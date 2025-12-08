import 'package:customer/app/core/utils/DateTimeHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_details_controller.dart';
import '../../../data/models/order/order_model.dart';

class OrderDetailsScreen extends GetView<OrderDetailsController> {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
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
                  onPressed: () => controller.fetchOrderDetails(controller.orderId),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        // Access the actual data object within the response
        final response = controller.order.value;
        final order = response?.data;
        
        if (order == null) {
          return const Center(child: Text("Order not found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, order),
              const SizedBox(height: 20),
              _buildSectionTitle("Items"),
              const SizedBox(height: 10),
              _buildItemsList(order),
              const SizedBox(height: 20),
              _buildSectionTitle("Payment Info"),
              const SizedBox(height: 10),
              _buildPaymentInfo(order),
              const SizedBox(height: 20),
              _buildSectionTitle("Delivery Address"),
              const SizedBox(height: 10),
              _buildAddressInfo(order),
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildSectionTitle("Notes"),
                const SizedBox(height: 10),
                Text(order.notes!),
              ]
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHeader(BuildContext context, OrderData order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.black: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.orderNo ?? order.id}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
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
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Scheduled Date"),
              Text(DateTimeHelper.formatDateMonth(order.scheduledDate!), style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(OrderData order) {
    if (order.items == null || order.items!.isEmpty) {
      return const Text("No items in this order");
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: order.items!.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = order.items![index];
          return ListTile(
            title: Text(item.product?.name ?? "Product"),
            subtitle: Text("Qty: ${item.qty} x ₹${item.price}"),
            trailing: Text(
              "₹${item.lineTotal}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentInfo(OrderData order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRow("Total Amount", "₹${order.totalAmount}", isBold: true),
          const SizedBox(height: 8),
          _buildRow("Paid Amount", "₹${order.paidAmount}", color: Colors.green),
          const SizedBox(height: 8),
          _buildRow("Pending Amount", "₹${order.pendingAmount}", color: Colors.red),
          const SizedBox(height: 8),
          _buildRow("Payment Status", order.paymentStatus ?? "Unpaid"),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(OrderData order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        order.deliveryAddress ?? "No address provided",
        style: const TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
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
