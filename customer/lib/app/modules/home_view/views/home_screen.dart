import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_screen_controller.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import '../../../global_widgets/cart_summary_fab.dart';

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
      // Use the reusable global widget for the FAB
      floatingActionButton: const CartSummaryFab(),
    );
  }
}
