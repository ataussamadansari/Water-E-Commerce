import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_screen_controller.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import '../../../routes/app_routes.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom App Bar (Fixed at top)
          const HomeAppBar(),

          // Scrollable Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => controller.onInit(),
              child: const HomeBody(),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final cart = controller.cartData.value;
        if (cart == null || cart.totalQty == null || cart.totalQty == 0) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed(Routes.cart);
          },
          backgroundColor: Colors.blue.shade700,
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            "${cart.totalQty} Items • ₹${cart.totalAmount ?? 0}",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }),
    );
  }
}
