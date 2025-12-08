import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_screen_controller.dart';

class HomeAppBar extends GetView<HomeScreenController> {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Colors.blue, // Using a fallback if AppColors.primary isn't found
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Profile Image
              GestureDetector(
                onTap: controller.gotoProfile,
                child: Obx(() {
                  final data = controller.profileData.value;
                  if (data != null && data.shopPhotoPath != null && data.shopPhotoPath.isNotEmpty) {
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white24,
                      backgroundImage: CachedNetworkImageProvider(data.shopPhotoPath!),
                    );
                  }
                  return const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 24, color: Colors.white),
                  );
                }),
              ),
              const SizedBox(width: 12),

              // Location Text
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery to",
                      style: TextStyle(
                        color: Colors.blue.shade100,
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      "Kandawa Varanasi, 221307",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Ledger Info Action
              GestureDetector(
                onTap: controller.gotoLedger,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Pending",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                      Obx(() {
                        final ledger = controller.ledgerData.value;
                        return Text(
                          ledger != null 
                              ? "₹${ledger.totalPendingAmount ?? '0'}" 
                              : "Loading...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Orders Button (My Orders)
              IconButton(
                onPressed: controller.gotoOrder, // Calls the method in your controller
                tooltip: "My Orders",
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for water, jars...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              // You can wire this up to controller.onSearchQueryChanged if implemented
            ),
          ),
        ],
      ),
    );
  }
}
