import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_screen_controller.dart';
import '../../../routes/app_routes.dart';

class CartScreen extends GetView<CartScreenController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: controller.clearCart,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: "Clear Cart",
          ),
        ],
      ),
      body: Obx(() {
        // Only show full screen loader if NOT updating a specific item
        if (controller.showFullScreenLoader) {
          return const Center(child: CircularProgressIndicator());
        }

        final cart = controller.cart.value;
        if (cart == null || cart.items == null || cart.items!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 60,
                  color: theme.disabledColor,
                ),
                const SizedBox(height: 10),
                Text("Your cart is empty", style: theme.textTheme.bodyLarge),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cart.items!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = cart.items![index];
                  // Check if this item is being updated
                  final isUpdating = controller.updatingProductId.value == item.product?.id;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Product Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.grey[800] : Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  image: item.product?.imagePath != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            item.product!.imagePath!,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: item.product?.imagePath == null
                                    ? Icon(
                                        Icons.water_drop,
                                        color: Colors.blue.shade300,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 15),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product?.name ?? "Product",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Qty Controls
                                    Row(
                                      children: [
                                        _buildQtyBtn(
                                          icon: Icons.remove, 
                                          onTap: () => controller.decrementQty(item.product!.id!.toInt(), item.qty!.toInt(), item.id!.toInt()),
                                          theme: theme
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            "${item.qty}",
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        _buildQtyBtn(
                                          icon: Icons.add, 
                                          onTap: () => controller.incrementQty(item.product!.id!.toInt(), item.qty!.toInt()),
                                          theme: theme
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Price & Remove
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹${(double.tryParse(item.product?.price ?? '0') ?? 0)}",
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => controller.removeItem(item.id),
                                    child: const Icon(Icons.delete, color: Colors.red, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Item Loading Overlay
                        if (isUpdating)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.black : Colors.white).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 24, 
                                  height: 24, 
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Checkout Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${cart.totalAmount ?? 0}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 25),

                  // Date Selection
                  InkWell(
                    onTap: () => controller.pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Text(
                              "Scheduled: ${controller.scheduledDate.value}",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 18,
                            color: theme.iconTheme.color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Notes Input
                  TextField(
                    controller: controller.notesController,
                    decoration: InputDecoration(
                      labelText: "Notes (Optional)",
                      hintText: "Add delivery instructions",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.checkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Checkout",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQtyBtn({required IconData icon, required VoidCallback onTap, required ThemeData theme}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 16, color: theme.iconTheme.color),
      ),
    );
  }
}
