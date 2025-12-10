import 'package:customer/app/data/services/profile/profile_service.dart';
import 'package:customer/app/data/services/ledger/ledger_service.dart';
import 'package:customer/app/data/services/cart/cart_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart'; 
import 'package:get/get.dart';

import '../../../data/models/products/product_model.dart';
import '../../../data/services/product/product_service.dart';
import '../../../routes/app_routes.dart';
import '../../../global_widgets/add_to_cart_bottom_sheet.dart';

class HomeScreenController extends GetxController {
  // Use Get.find since services are injected in AppBindings
  final ProductService _productService = Get.find<ProductService>();
  final ProfileService _profileService = Get.find<ProfileService>();
  final LedgerService _ledgerService = Get.find<LedgerService>();
  final CartService _cartService = Get.find<CartService>();

  // State Variables
  bool get isLoading => _productService.isLoading.value;

  RxList<ProductModel> get productList => _productService.products;

  // Profile Data Getter
  get profileData => _profileService.profileData;
  
  // Ledger Data Getter
  get ledgerData => _ledgerService.ledgerData;
  
  // Cart Data Getter
  get cartData => _cartService.cart;

  @override
  void onInit() {
    super.onInit();
    // Refresh data on Home init
    _productService.fetchProducts();
    _profileService.fetchProfile();
    _ledgerService.fetchLedger();
    _cartService.fetchCart();

    _syncFcmToken();
  }

  // --- FCM Token for messaging ---
  void _syncFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if(token != null) {
        debugPrint("👉 Syncing FCM Token: $token");
        // Example: await _profileService.updateFcmToken(token);
      }
    } catch(e) {
      debugPrint("👉 Error syncing FCM Token: $e");
    }
  }
  
  // --- Logic to Add to Cart ---
  Future<void> addToCart({
    required int productId,
    required int qty,
  }) async {
    Get.back(); // Close the BottomSheet immediately
    
    // Call service (it handles snack-bars and errors internally)
    await _cartService.addToCart(productId, qty);
  }

  // --- UI Logic: Show Bottom Sheet ---
  void addToCartDialog(BuildContext context, ProductModel product) {
    Get.bottomSheet(
      AddToCartBottomSheet(
        product: product,
        onAdd: (qty) {
          addToCart(
            productId: product.id!.toInt(),
            qty: qty,
          );
        },
      ),
      isScrollControlled: true, 
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
