import 'package:customer/app/core/utils/helpers.dart';
import 'package:customer/app/data/services/orders/order_service.dart';
import 'package:customer/app/data/services/profile/profile_service.dart';
import 'package:customer/app/data/services/ledger/ledger_service.dart';
import 'package:customer/app/data/services/cart/cart_service.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../../data/models/products/product_model.dart';
import '../../../data/services/product/product_service.dart';
import '../../../routes/app_routes.dart';

class HomeScreenController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final OrderService _orderService = Get.find<OrderService>();
  final ProfileService _profileService = Get.put(ProfileService());
  final LedgerService _ledgerService = Get.put(LedgerService());
  final CartService _cartService = Get.put(CartService());

  // State Variables
  bool get isLoading => _productService.isLoading.value;

  RxList<ProductModel> get productList => _productService.products;

  // Profile Data Getter
  get profileData => _profileService.profileData;
  
  // Ledger Data Getter
  get ledgerData => _ledgerService.ledgerData;
  
  // Cart Data Getter
  get cartData => _cartService.cart;

  // Loading state for the order button inside the bottom sheet
  final RxBool isOrdering = false.obs;
  RxInt cartCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _productService.fetchProducts();
    _profileService.fetchProfile();
    _ledgerService.fetchLedger();
    _cartService.fetchCart();
  }
  
  // --- Logic to Add to Cart ---
  Future<void> addToCart({
    required int productId,
    required int qty,
  }) async {
    try {
      isOrdering.value = true;
      Get.back(); // Close the BottomSheet

      await _cartService.addToCart(productId, qty);

    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isOrdering.value = false;
    }
  }

  // --- UI Logic: Show Bottom Sheet ---
  void addToCartDialog(BuildContext context, ProductModel product) {
    // Determine initial quantity. 
    // If minOrderQty is available and > 0, use it. Otherwise use 1.
    int initialQty = 1;
    if (product.minOrderQty != null && product.minOrderQty is num && (product.minOrderQty as num) > 0) {
      initialQty = (product.minOrderQty as num).toInt();
    }
    
    final qtyController = TextEditingController(text: initialQty.toString());
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Add ${product.name ?? 'Item'} to Cart",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 1. Quantity Input
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_bag_outlined),
              ),
            ),
            const SizedBox(height: 5),
            if (product.minOrderQty != null)
               Text("Minimum Order Quantity: ${product.minOrderQty}", style: TextStyle(color: Colors.grey, fontSize: 12)),
            
            const SizedBox(height: 20),

            // 2. Add Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (qtyController.text.isEmpty) return;
                  
                  int qty = int.tryParse(qtyController.text) ?? initialQty;
                  
                  // Optional: Validate min quantity again if needed, or let server handle it.
                  // Usually better to validate client side too if possible.
                  if (qty < initialQty) {
                     Get.snackbar("Invalid Quantity", "Minimum quantity is $initialQty");
                     return;
                  }

                  addToCart(
                    productId: product.id!.toInt(),
                    qty: qty,
                  );
                },
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allows sheet to rise with keyboard
    );
  }

  void gotoOrder() {
    Get.toNamed(Routes.orders);
  }

  void gotoProfile() {
    Get.toNamed(Routes.profile);
  }
  
  void gotoLedger() {
    Get.toNamed(Routes.ledger);
  }
}
