import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/products/product_model.dart';

class AddToCartBottomSheet extends StatelessWidget {
  final ProductModel product;
  final Function(int qty) onAdd;

  const AddToCartBottomSheet({
    super.key,
    required this.product,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    int initialQty = 1;
    if (product.minOrderQty != null && product.minOrderQty is num && (product.minOrderQty as num) > 0) {
      initialQty = (product.minOrderQty as num).toInt();
    }
    
    final qtyController = TextEditingController(text: initialQty.toString());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
             Text("Minimum Order Quantity: ${product.minOrderQty}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          
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
                
                if (qty < initialQty) {
                   Get.snackbar("Invalid Quantity", "Minimum quantity is $initialQty");
                   return;
                }

                onAdd(qty);
              },
              child: const Text(
                "Add to Cart",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
