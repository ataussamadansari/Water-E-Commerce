import 'package:customer/app/data/services/cart/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for Cart Screen
class CartScreenController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  // Getters
  get cart => _cartService.cart;
  bool get isLoading => _cartService.isLoading.value;
  
  // Track which item is being updated to avoid full screen loader
  final Rxn<int> updatingProductId = Rxn<int>();

  // Computed property: Only show full screen loader if NOT updating a specific item
  bool get showFullScreenLoader => isLoading && updatingProductId.value == null;
  
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

  Future<void> incrementQty(int productId, int currentQty) async {
    updatingProductId.value = productId;
    try {
      // Send new TOTAL quantity
      await _cartService.addToCart(productId, currentQty + 1);
    } finally {
      updatingProductId.value = null;
    }
  }

  Future<void> decrementQty(int productId, int currentQty, int cartItemId) async {
    updatingProductId.value = productId;
    try {
      if (currentQty > 1) {
        // Send new TOTAL quantity
        await _cartService.addToCart(productId, currentQty - 1);
      } else {
        // Remove item if qty goes to 0
        await removeItem(cartItemId);
      }
    } finally {
      updatingProductId.value = null;
    }
  }

  Future<void> removeItem(int cartItemId) async {
    // For remove item, we might want to show loader on that item too?
    // But removeItem uses cartItemId. updatingProductId tracks productId.
    // If we want inline loader for remove, we need to track cartItemId or map back.
    // For now, let's just let remove trigger full screen or handle it separately if needed.
    // The user specifically asked for "list item loading" which usually refers to qty update.
    // However, if we remove, full screen load is probably fine or we can track it too.
    // Let's keep remove as is (full screen) or simply let it be covered by `isLoading`.
    // If we want to avoid full screen for remove, we need to set updatingProductId (if we can map it) or add updatingCartItemId.
    // Given the prompt "full screen load na ho jisko update kar rahe h bas wahi list item loading kare", it implies update.
    await _cartService.removeFromCart(cartItemId);
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

    final payload = {
      "scheduled_date": scheduledDate.value,
      "notes": notesController.text,
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
