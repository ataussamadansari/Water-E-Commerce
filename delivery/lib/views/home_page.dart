import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/delivery_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final DeliveryController controller = Get.put(DeliveryController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery App'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.deliveries.isEmpty) {
          return const Center(child: Text('No deliveries assigned'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchDeliveries,
          child: ListView.builder(
            itemCount: controller.deliveries.length,
            itemBuilder: (context, index) {
              final delivery = controller.deliveries[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(
                    Icons.local_shipping,
                    color: Colors.green,
                  ),
                  title: Text('Order #${delivery['order_number'] ?? 'N/A'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${delivery['status'] ?? 'N/A'}'),
                      Text('Address: ${delivery['delivery_address'] ?? 'N/A'}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (status) {
                      controller.updateDeliveryStatus(delivery['id'], status);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'in_transit',
                        child: Text('In Transit'),
                      ),
                      const PopupMenuItem(
                        value: 'delivered',
                        child: Text('Delivered'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
