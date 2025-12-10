import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/cart/cart_service.dart';
import '../routes/app_routes.dart';

class CartSummaryFab extends StatelessWidget {
  const CartSummaryFab({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Get.find to access the persistent CartService
    final CartService cartService = Get.find<CartService>();

    return Obx(() {
      final cart = cartService.cart.value;
      // Hide if cart is empty
      if (cart == null || cart.items == null || cart.items!.isEmpty) {
        return const SizedBox.shrink();
      }

      return FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(Routes.cart);
        },
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        label: Text(
          "${cart.items!.length} Items • ₹${cart.totalAmount ?? 0}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    });
  }
}
