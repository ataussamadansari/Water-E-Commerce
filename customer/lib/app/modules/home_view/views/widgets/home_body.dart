import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/products/product_model.dart';
import '../../controllers/home_screen_controller.dart';

class HomeBody extends GetView<HomeScreenController> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.productList.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text("No products available"),
            ],
          ),
        );
      }

      // Filtered List based on Search
      final displayList = controller.productList;

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Taller cards
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final product = displayList[index];

          // Animation Wrapper
          return AnimatedProductCard(
            product: product,
            index: index,
            onAdd: () => controller.addToCartDialog(context, product),
          );
        },
      );
    });
  }
}

class AnimatedProductCard extends StatefulWidget {
  final ProductModel product;
  final int index;
  final VoidCallback onAdd;

  const AnimatedProductCard({
    super.key,
    required this.product,
    required this.index,
    required this.onAdd,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Stagger effect: Delay start based on index
    final delay = Duration(milliseconds: widget.index * 100);
    Future.delayed(delay, () {
      if (mounted) _animController.forward();
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Start slightly down
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: widget.product.imagePath != null
                        ? Image.network(
                      widget.product.imagePath!,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.water_drop, size: 50, color: Colors.blueAccent),
                    )
                        : const Icon(Icons.water_drop, size: 50, color: Colors.blueAccent),
                  ),
                ),
              ),

              // Info Section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name ?? "Water Product",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.description ?? "Fresh & Pure",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      // Price and Add Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${widget.product.price ?? '0'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          InkWell(
                            onTap: widget.onAdd,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
