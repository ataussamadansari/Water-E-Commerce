import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/products_screen_controller.dart';

class ProductsScreen extends GetView<ProductsScreenController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.searchProducts,
              decoration: InputDecoration(
                hintText: "Search by name or SKU...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          // Product List
          Expanded(
            child: Obx(() {
              if (controller.productService.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredProducts.isEmpty) {
                return const Center(child: Text("No products found."));
              }
              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 100, right: 16, left: 16),
                itemCount: controller.filteredProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  // --- SLIDE TO DELETE IMPLEMENTATION ---
                  return Dismissible(
                    // Unique key is required for Dismissible
                    key: Key(product.id.toString()),
                    direction: DismissDirection.endToStart, // Swipe from right to left

                    // Background (Red color with Delete Icon)
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white, size: 28),
                    ),

                    confirmDismiss: (direction) async {
                      return await Get.dialog<bool>(
                        CupertinoAlertDialog(
                          title: const Text("Delete Product"),
                          content: Text("Are you sure you want to delete '${product.name}'?"),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text("Cancel"),
                              onPressed: () => Get.back(result: false),
                            ),
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () => Get.back(result: true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (_) {
                      controller.deleteProduct(product.id!);
                    },
                    child: Card(
                      elevation: 1,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        onTap: () => controller.gotoEditProduct(product),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          child: product.imagePath != null && product.imagePath!.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(product.imagePath!, fit: BoxFit.cover),
                          )
                              : const Icon(Icons.water_drop, color: Colors.blue),
                        ),
                        title: Text(product.name ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("SKU: ${product.sku ?? 'N/A'} • Stock: ${product.stockQty ?? 0}"),
                        trailing: Text(
                          "₹${product.price ?? '0.00'}",
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
