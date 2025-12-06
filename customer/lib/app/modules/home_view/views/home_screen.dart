import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/products/product_model.dart';
import '../controllers/home_screen_controller.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Brand Colors
    final primaryColor = Colors.blue.shade700;
    final bgColor = Colors.grey.shade100;

    return Scaffold(
      appBar: _buildAppBar(primaryColor),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (controller.productList.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        return RefreshIndicator(
          onRefresh: () async => controller.onInit(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search Bar
                _buildSearchBar(),

                // 2. Promo Banner
                _buildPromoBanner(primaryColor),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Text(
                    "Popular Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // 3. Product Grid
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75, // Controls height of the card
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: controller.productList.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: controller.productList[index],
                      // CHANGE HERE: Open the BottomSheet instead of direct API call
                      onAdd: () => controller.showOrderDialog(context, controller.productList[index]),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- Widgets Components (Kept same as your code) ---

  AppBar _buildAppBar(Color primaryColor) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deliver to", style: TextStyle(fontSize: 12, color: Colors.blue.shade100)),
          const Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Text("Home - 123, Green Street", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
            ],
          ),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                controller.gotoOrder();
              }, // Navigate to Cart
            ),
            Obx(() => controller.cartCount.value > 0
                ? Positioned(
              right: 8,
              top: 8,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Text(
                  "${controller.cartCount.value}",
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            )
                : const SizedBox.shrink()
            )
          ],
        )
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search 20L jar, bottles...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(Color primaryColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, Colors.blue.shade400]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Hydrate & Save!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 5),
                  const Text("Get 10% off on your first subscription.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        minimumSize: const Size(80, 30)
                    ),
                    onPressed: () {},
                    child: const Text("Order Now", style: TextStyle(fontSize: 12)),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(Icons.water_drop, size: 100, color: Colors.white.withOpacity(0.3)),
          )
        ],
      ),
    );
  }
}

// --- Product Card Widget (Kept same) ---

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  product.imagePath ?? "",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? "Unknown",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${product.price}",
                      style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
