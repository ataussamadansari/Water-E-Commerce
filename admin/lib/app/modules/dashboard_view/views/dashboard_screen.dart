import 'package:admin/app/data/services/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/app/routes/app_routes.dart';
import '../controllers/dashboard_screen_controller.dart';
import 'widgets/water_wave_background.dart';

import 'package:admin/app/global_widgets/common_widgets.dart';
import 'package:admin/app/global_widgets/customer_widgets.dart';
import 'package:admin/app/global_widgets/order_widgets.dart';
import 'package:admin/app/global_widgets/product_widgets.dart';

class DashboardScreen extends GetView<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final color = context.isDarkMode ? const Color(0xFF1E1F22) : const Color(0xFFF5F7FA);
    final color = context.theme.scaffoldBackgroundColor;
    // final titleColor = context.isDarkMode ? Colors.black : Colors.white;
    final titleColor = color;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // --- CUSTOM ANIMATED HEADER ---
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    // Gradient Background
                    Container(
                      height: 190,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF023E8A), // Deep Blue
                            Color(0xFF0096C7), // Light Blue
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),

                    // Decorative Elements
                    Positioned(
                      top: -20,
                      right: -20,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),

                    // Header Content
                    Positioned(
                      bottom: 40,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, Admin 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Let's manage your water supply.",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Profile Icon in top right
                    Positioned(
                      top: 40,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          StorageServices.to.removeToken();
                          Get.offAllNamed(Routes.auth);
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Wave Animation
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: WaterWaveBackground(height: 50, color: color),
                    ),
                  ],
                ),
              ),
            ),

            // --- QUICK ACTIONS GRID ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    QuickActionButton(
                      icon: Icons.map,
                      label: "All\nRegions",
                      color: Colors.orange,
                      bgColor: titleColor,
                      onTap: () => controller.gotoRegions(),
                    ),
                    QuickActionButton(
                      icon: Icons.inventory_2,
                      label: "Manage\nStock",
                      color: Colors.purple,
                      bgColor: titleColor,
                      onTap: () => controller.gotoManageStock(),
                    ),
                    QuickActionButton(
                      icon: Icons.receipt_long,
                      label: "Customer\nLedger",
                      color: Colors.teal,
                      bgColor: titleColor,
                      onTap: () => controller.gotoLedger(),
                    ),
                    QuickActionButton(
                      icon: Icons.people_alt,
                      label: "Manage\nUsers",
                      color: Colors.blueGrey,
                      bgColor: titleColor,
                      onTap: () => controller.gotoUsers(),
                    ),
                  ],
                ),
              ),
            ),

            SectionHeader(
              title: "Overview",
              color: titleColor,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    children: [
                      StatCard(
                        title: 'Total Revenue',
                        value:
                            '₹${controller.totalRevenue.value.toStringAsFixed(0)}',
                        icon: Icons.currency_rupee,
                        color: Colors.green,
                      ),
                      StatCard(
                        title: 'Total Orders',
                        value: controller.totalOrders.toString(),
                        icon: Icons.shopping_cart_outlined,
                        color: Colors.blue,
                      ),
                      StatCard(
                        title: 'Total Customers',
                        value: controller.totalCustomers.toString(),
                        icon: Icons.groups_outlined,
                        color: Colors.orange,
                      ),
                      StatCard(
                        title: 'Pending Orders',
                        value: controller.pendingOrders.toString(),
                        icon: Icons.pending_actions_outlined,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SectionHeader(
              title: "Recent Orders",
              color: titleColor,
              actionText: "View All",
              onTap: () => controller.gotoOrders(),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoadingOrders) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.isErrorOrders) {
                  return Center(
                    child: Text(controller.hasErrorOrders),
                  );
                }

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: titleColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (controller.orders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: Text("No recent orders found.")),
                        )
                      else
                        ...controller.orders.take(5).map((order) {
                          final isLast =
                              controller.orders.take(5).last == order;
                          return OrderListTile(
                            order: order,
                            isLast: isLast,
                          );
                        }),
                    ],
                  ),
                );
              }),
            ),

            SectionHeader(
              title: "Customers",
              color: titleColor,
              actionText: "View All",
              onTap: () => controller.gotoCustomers(),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoadingCustomers) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (controller.isErrorCustomer) {
                  return Center(
                    child: Text(controller.hasErrorCustomer),
                  );
                }

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: titleColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.customers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: Text("No customers found.")),
                        )
                      else
                        ...controller.customers.take(5).map(
                              (customer) => CustomerListTile(
                                customer: customer,
                                onEyeTap: () => controller
                                    .showCustomerDetailsBottomSheet(customer),
                              ),
                            ),
                    ],
                  ),
                );
              }),
            ),

            SectionHeader(
              title: "Popular Products",
              color: titleColor,
              actionText: "View All",
              onTap: () => controller.gotoProducts(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 170,
                      child: Obx(() {
                        if (controller.isLoadingProducts) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.isErrorProduct) {
                          return Center(
                            child: Text(controller.hasErrorProduct),
                          );
                        }

                        if (controller.products.isEmpty) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text("No products found"),
                            ),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];
                            return ProductCard(
                              product: product,
                              bgColor: titleColor,
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptions(context),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 30,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: context.isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Quick Add",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OptionItem(
                  icon: Icons.person_add,
                  color: Colors.blue,
                  label: "Customer",
                  onTap: () {
                    Get.back();
                  },
                ),
                OptionItem(
                  icon: Icons.add_box,
                  color: Colors.green,
                  label: "Product",
                  onTap: () {
                    Get.back();
                    controller.gotoAddProduct();
                  },
                ),
                OptionItem(
                  icon: Icons.map,
                  color: Colors.orange,
                  label: "Region",
                  onTap: () {
                    Get.back();
                    controller.gotoAddRegion();
                  },
                ),
                OptionItem(
                  icon: Icons.person_add_alt_1,
                  color: Colors.purple,
                  label: "User",
                  onTap: () {
                    Get.back();
                    controller.gotoAddUser();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
