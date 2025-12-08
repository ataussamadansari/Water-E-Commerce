import 'package:customer/app/data/services/cart/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreenController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  // Getters
  get cart => _cartService.cart;
  bool get isLoading => _cartService.isLoading.value;
  
  // Checkout Fields
  final notesController = TextEditingController();
  final RxString scheduledDate = DateTime.now().toIso8601String().split('T')[0].obs;

  @override
  void onInit() {
    super.onInit();
    refreshCart();
  }

  Future<void> refreshCart() async {
    await _cartService.fetchCart();
  }

  Future<void> updateQty(int productId, int qty) async {
    // Usually update qty is just adding/removing. 
    // If you have a specific update endpoint, use that.
    // For now, assume adding overwrites or we calculate difference?
    // Actually, traditionally addToCart adds to existing. 
    // If you want to SET quantity, you might need a different logic or remove then add.
    // Let's assume for now the user can only add or remove items one by one or we just use addToCart for positive changes.
    // But wait, the API was /addCart. 
    // If I want to increase by 1, I add 1.
    // If I want to decrease, I assume I remove?
    // Let's stick to simple "Remove item" button for now, or if we want +/-, we need to know if Add adds relative or absolute.
    // Usually Add is relative. 
    // For simplicity in this iteration:
    // User can Remove item completely.
    // User can Add more items from home screen.
    // But in Cart Screen, usually we want +/-.
    // If Add is relative, then (+) calls addToCart(id, 1).
    // What about (-)? Is there a remove one? 
    // The API `removeItem` usually removes the whole row. 
    // I will implement "Remove Item" for now.
    // If we need decrement, we might need a specific endpoint or logic.
    
    // Simplification: Just allow removing items for now.
  }

  Future<void> removeItem(int productId) async {
    await _cartService.removeFromCart(productId);
  }

  Future<void> clearCart() async {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text("Clear Cart"),
        content: const Text("Are you sure you want to remove all items?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Clear"),
            onPressed: () {
              Get.back();
              _cartService.clearCart();
            },
          ),
        ],
      ),
    );
  }

  Future<void> checkout() async {
    if (cart.value == null || cart.value!.items == null || cart.value!.items!.isEmpty) {
      Get.snackbar("Error", "Cart is empty");
      return;
    }

    // Prepare payload
    // The API might expect just scheduled_date and notes, as items are in cart session.
    // Or it might expect the items again. 
    // Based on `checkout` endpoint in `CartRepository` taking `data`, let's send common fields.
    
    final payload = {
      "scheduled_date": scheduledDate.value,
      "notes": notesController.text,
      // "items": ... // If backend needs items list, we map it from cart.value.items
      // Usually session based cart checkout doesn't require sending items again.
      // I will assume session based.
    };

    final success = await _cartService.checkout(payload);
    if (success) {
      Get.back(); // Go back to home
    }
  }

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      scheduledDate.value = picked.toIso8601String().split('T')[0];
    }
  }
}
