import 'package:admin/app/data/services/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_screen_controller.dart';
import 'widgets/dashboard_widgets.dart';
import 'widgets/water_wave_background.dart';

class DashboardScreen extends GetView<DashboardScreenController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.isDarkMode ? Color(0xFF1E1F22) : Color(0xFFF5F7FA);
    final titleColor = context.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.onRefresh, // Connect to the controller's method
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // physics: const BouncingScrollPhysics(),
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
                    DashboardWidgets.buildQuickAction(
                      Icons.map,
                      "All\nRegions",
                      Colors.orange,
                      titleColor,
                      () {
                        controller.gotoRegions();
                      },
                    ),
                    DashboardWidgets.buildQuickAction(
                      Icons.inventory_2,
                      "Manage\nStock",
                      Colors.purple,
                      titleColor,
                      () {
                        controller.gotoManageStock();
                      },
                    ),
                    DashboardWidgets.buildQuickAction(
                      Icons.bar_chart,
                      "View\nReports",
                      Colors.teal,
                      titleColor,
                      () {},
                    ),
                    DashboardWidgets.buildQuickAction(
                      Icons.settings,
                      "Settings\n",
                      Colors.blueGrey,
                      titleColor,
                      () {},
                    ),
                  ],
                ),
              ),
            ),

            DashboardWidgets.buildSectionHeader("Overview", titleColor, () {}),
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
                          childAspectRatio: 1.5, // Adjust if content overflows
                        ),
                    // Build stat cards dynamically from controller's observables
                    children: [
                      DashboardWidgets.buildStatCard(
                        title: 'Total Revenue',
                        value:
                            '₹${controller.totalRevenue.value.toStringAsFixed(0)}', // Format to integer
                        icon: Icons.currency_rupee,
                        color: Colors.green,
                      ),
                      DashboardWidgets.buildStatCard(
                        title: 'Total Orders',
                        value: controller.totalOrders.toString(),
                        icon: Icons.shopping_cart_outlined,
                        color: Colors.blue,
                      ),
                      DashboardWidgets.buildStatCard(
                        title: 'Total Customers',
                        value: controller.totalCustomers.toString(),
                        icon: Icons.groups_outlined,
                        color: Colors.orange,
                      ),
                      DashboardWidgets.buildStatCard(
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

            DashboardWidgets.buildSectionHeader(
              "Recent Orders",
              titleColor,
              actionText: "View All",
              () {
                controller.gotoOrders();
              },
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

                if(controller.isErrorOrders) {
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
                        // Use the observable `orders` list and limit to 5
                        ...controller.orders.take(5).map((order) {
                          final isLast =
                              controller.orders.take(5).last == order;
                          return DashboardWidgets.buildOrderItem(order, isLast);
                        }),
                    ],
                  ),
                );
              }),
            ),

            DashboardWidgets.buildSectionHeader(
              "Customers",
              titleColor,
              actionText: "View All",
              () {
                controller.gotoCustomers();
              },
            ),
            // --- FIX STARTS HERE ---
            SliverToBoxAdapter(
              child: Obx(() {
                // Wrap with Obx to listen for changes
                if (controller.isLoadingCustomers) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if(controller.isErrorCustomer) {
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
                      // Use the observable customers list
                      if (controller.orders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: Text("No customers found.")),
                        )
                      else
                        ...controller.customers
                            .take(5)
                            .map(
                              (customer) =>
                                  DashboardWidgets.buildCustomerCard(customer),
                            ),
                    ],
                  ),
                );
              }),
            ),

            // --- FIX ENDS HERE ---
            DashboardWidgets.buildSectionHeader(
              "Popular Products",
              titleColor,
              actionText: "View All",
              () {
                controller.gotoProducts();
              },
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

                        if(controller.isErrorProduct) {
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
                            return DashboardWidgets.buildProductCard(
                              product,
                              titleColor,
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

  // --- ADD MENU BOTTOM SHEET ---
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
            const Text(
              "Quick Add",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DashboardWidgets.buildOptionItem(
                  icon: Icons.inventory_2_outlined,
                  color: Colors.blue,
                  label: "Add\nProduct",
                  onTap: () {
                    controller.gotoAddProduct();
                  },
                ),
                DashboardWidgets.buildOptionItem(
                  icon: Icons.map_outlined,
                  color: Colors.orange,
                  label: "Add\nRegion",
                  onTap: () {
                    controller.gotoAddRegion();
                  },
                ),
                DashboardWidgets.buildOptionItem(
                  icon: Icons.shopping_cart_outlined,
                  color: Colors.green,
                  label: "New\nOrder",
                  onTap: () {
                    Get.back();
                  },
                ),
                DashboardWidgets.buildOptionItem(
                  icon: Icons.grid_view_rounded,
                  color: Colors.purple,
                  label: "More",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 250),
      isScrollControlled: true,
    );
  }
}
