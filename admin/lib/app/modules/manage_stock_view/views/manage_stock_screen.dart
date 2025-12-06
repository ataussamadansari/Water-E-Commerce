import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/products/product_model.dart';
import '../controllers/manage_stock_screen_controller.dart';

class ManageStockScreen extends GetView<ManageStockScreenController> {
  const ManageStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Stock"),
      ),
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Product...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: controller.search,
            ),
          ),

          // --- Product List ---
          Expanded(
            child: Obx(() {
              if (controller.productService.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return const Center(child: Text("No products found"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  // Use a separate widget to manage the TextEditingController state
                  return StockUpdateCard(
                    product: product,
                    onSave: (stock, isActive) => controller.updateStockAndStatus(
                      product.id!,
                      stock,
                      isActive,
                    ),
                    isUpdating: controller.updatingItems[product.id] ?? false,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// Helper Widget to manage Input State per row
// ----------------------------------------------------------------------
class StockUpdateCard extends StatefulWidget {
  final Product product;
  final Function(String stock, bool isActive) onSave;
  final bool isUpdating;

  const StockUpdateCard({
    super.key,
    required this.product,
    required this.onSave,
    required this.isUpdating,
  });

  @override
  State<StockUpdateCard> createState() => _StockUpdateCardState();
}

class _StockUpdateCardState extends State<StockUpdateCard> {
  late TextEditingController _stockCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  // Update fields if the parent product updates (e.g. after a successful save)
  @override
  void didUpdateWidget(covariant StockUpdateCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product != widget.product) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    _stockCtrl = TextEditingController(text: widget.product.stockQty?.toString() ?? '0');
    _isActive = widget.product.isActive ?? true;
  }

  @override
  void dispose() {
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Product Name & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.product.name ?? "Unnamed Product",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _isActive ? "ACTIVE" : "INACTIVE",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _isActive ? Colors.green : Colors.red,
                    ),
                  ),
                )
              ],
            ),

            const Divider(height: 24),

            // Row 2: Controls
            Row(
              children: [
                // Stock Input
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _stockCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stock Qty",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Active Switch
                Column(
                  children: [
                    const Text("Active", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Switch(
                      value: _isActive,
                      onChanged: (val) {
                        setState(() {
                          _isActive = val;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // Save Button
                widget.isUpdating
                    ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)
                  ),
                )
                    : ElevatedButton(
                  onPressed: () {
                    widget.onSave(_stockCtrl.text, _isActive);
                  },
                  style: IconButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ), child: Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
