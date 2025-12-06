import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/sale_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final SaleController controller = Get.put(SaleController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sale App'),
          backgroundColor: Colors.orange,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.point_of_sale), text: 'Sales'),
              Tab(icon: Icon(Icons.inventory), text: 'Products'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => authController.logout(),
            ),
          ],
        ),
        body: TabBarView(children: [_buildSalesTab(), _buildProductsTab()]),
      ),
    );
  }

  Widget _buildSalesTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.sales.isEmpty) {
        return const Center(child: Text('No sales found'));
      }

      return RefreshIndicator(
        onRefresh: controller.fetchSales,
        child: ListView.builder(
          itemCount: controller.sales.length,
          itemBuilder: (context, index) {
            final sale = controller.sales[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.point_of_sale, color: Colors.orange),
                title: Text('Sale #${sale['id'] ?? 'N/A'}'),
                subtitle: Text('Customer: ${sale['customer_name'] ?? 'N/A'}'),
                trailing: Text('\$${sale['total_amount'] ?? 0}'),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildProductsTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return RefreshIndicator(
        onRefresh: controller.fetchProducts,
        child: ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.water_drop, color: Colors.orange),
                title: Text(product['name'] ?? 'N/A'),
                subtitle: Text('Stock: ${product['stock'] ?? 0}'),
                trailing: Text('\$${product['price'] ?? 0}'),
              ),
            );
          },
        ),
      );
    });
  }
}
