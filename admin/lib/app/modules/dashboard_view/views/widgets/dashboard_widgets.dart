import 'package:admin/app/data/models/customers/customer_model.dart';
import 'package:admin/app/data/models/orders/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../../../../data/models/products/product_model.dart';

class DashboardWidgets {
  // --- QUICK ACTION BUTTON ---
  static Widget buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Color bgColor,
    Callback onTap,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // --- SECTION HEADER ---
  static SliverToBoxAdapter buildSectionHeader(
    BuildContext context,
    String title,
    Color color,
    Callback onTap, {
    String? actionText,
  }) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (actionText != null)
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0096C7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        actionText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0096C7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: Color(0xFF0096C7),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- STAT CARD (Updated) ---
  static Widget buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceVariant : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        // Center content vertically
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // --- ORDER ITEM ---
  static Widget buildOrderItem(BuildContext context, Order order, bool isLast) {
    final theme = Theme.of(context);
    Color statusColor;
    IconData statusIcon;

    // Use the status from the API response
    switch (order.status?.toLowerCase()) {
      case 'delivered':
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'processing':
        statusColor = Colors.orange;
        statusIcon = Icons.refresh;
        break;
      case 'pending':
      case 'created':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(statusIcon, size: 20, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        // Use the customer's shop name from the nested object
                        order.customer?.shopName ?? 'N/A',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "₹${order.totalAmount ?? '0.00'}", // Use totalAmount
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order.orderNo ?? 'No Order ID', // Use orderNo
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CUSTOMER CARD ---
  static Widget buildCustomerCard(BuildContext context, Customer customer, {VoidCallback? onEyeTap}) {
    final theme = Theme.of(context);
    // Safely get the first letter of the shop name, default to 'C' if empty
    final String initial = (customer.shopName?.isNotEmpty == true)
        ? customer.shopName![0].toUpperCase()
        : 'C';

    // Safely build the address string by filtering out null or empty parts
    final addressParts = [
      customer.addressLine,
      customer.city,
      customer.state,
      customer.pincode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    final String fullAddress = addressParts.join(', ');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: (customer.shopPhotoPath != null &&
                    customer.shopPhotoPath.toString().isNotEmpty)
                ? NetworkImage(customer.shopPhotoPath.toString())
                : null,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: (customer.shopPhotoPath == null ||
                    customer.shopPhotoPath.toString().isEmpty)
                ? Text(
                    initial, // Use the dynamic initial
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.shopName ?? "Unknown Shop", // Use shopName
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (fullAddress.isNotEmpty) // Show only if address exists
                  Text(
                    fullAddress, // Use the safely built address string
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEyeTap,
            icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  // --- UPDATED PRODUCT CARD ---
  static Widget buildProductCard(BuildContext context, Product product, Color bgColor) {
    final theme = Theme.of(context);
    // FIX: Convert stockQty (String) → int
    final int stock = int.tryParse(product.stockQty?.toString() ?? "0") ?? 0;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surfaceVariant : bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      image:
                          product.imagePath != null &&
                              product.imagePath!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(product.imagePath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        (product.imagePath == null ||
                            product.imagePath!.isEmpty)
                        ? const Center(
                            child: Icon(
                              Icons.water_drop,
                              size: 30,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    product.name ?? "Unknown",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    product.description ?? "No description",
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),

              // PRICE & STOCK
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${product.price ?? '0'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),

                  // FIXED STOCK BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: stock > 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$stock left',
                      style: TextStyle(
                        fontSize: 10,
                        color: stock > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ADD MENU OPTION ---
  static Widget buildOptionItem({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}