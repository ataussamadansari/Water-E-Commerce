import 'package:customer/app/data/services/orders/order_service.dart';
import 'package:flutter/material.dart'; // Changed to material for Colors & Icons
import 'package:get/get.dart';

import '../../../data/models/products/product_model.dart';
import '../../../data/services/product/product_service.dart';
import '../../../routes/app_routes.dart';

class HomeScreenController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final OrderService _orderService = Get.find<OrderService>();

  // State Variables
  bool get isLoading => _productService.isLoading.value;
  RxList<ProductModel> get productList => _productService.products;

  // Loading state for the order button inside the bottom sheet
  final RxBool isOrdering = false.obs;
  RxInt cartCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _productService.fetchProducts();
  }

  // --- Logic to Place Order ---
  Future<void> orderPlace({
    required int productId,
    required int qty,
    required String scheduledDate,
    required String notes,
  }) async {

    try {
      isOrdering.value = true;
      Get.back(); // Close the BottomSheet immediately

      final payload = {
        "items": [
          {
            "product_id": productId,
            "qty": qty,
          }
        ],
        "scheduled_date": scheduledDate,
        "notes": notes
      };

      await _orderService.placeOrder(payload);

    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isOrdering.value = false;
    }
  }

  // --- UI Logic: Show Bottom Sheet ---
  void showOrderDialog(BuildContext context, ProductModel product) {
    final qtyController = TextEditingController(text: "1");
    final notesController = TextEditingController();

    // Default date: Today
    RxString selectedDate = DateTime.now().toIso8601String().split('T')[0].obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration:  BoxDecoration(
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
                      "Order ${product.name ?? 'Item'}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close))
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
            const SizedBox(height: 15),

            // 2. Date Picker
            Obx(() => InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  selectedDate.value = picked.toIso8601String().split('T')[0];
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date: ${selectedDate.value}"),
                    const Icon(Icons.calendar_today, color: Colors.blue),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 15),

            // 3. Notes Input
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: "Notes (Optional)",
                hintText: "e.g. Leave at front door",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_alt_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () {
                  if (qtyController.text.isEmpty) return;

                  orderPlace(
                    productId: product.id!.toInt(),
                    qty: int.tryParse(qtyController.text) ?? 1,
                    scheduledDate: selectedDate.value,
                    notes: notesController.text,
                  );
                },
                child: const Text("Confirm Order", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true, // Allows sheet to rise with keyboard
    );
  }

  void gotoOrder() {
    Get.toNamed(Routes.orders);
  }
}
