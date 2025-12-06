import 'package:admin/app/modules/regions_view/controllers/regions_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class RegionsScreen extends GetView<RegionsScreenController> {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text("Manage Regions"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.regions.isEmpty) {
          return const Center(
            child: Text("No regions found. Add one to get started!"),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 120, left: 16, right: 1),
            itemCount: controller.regions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final region = controller.regions[index];

              // --- SLIDE TO DELETE IMPLEMENTATION ---
              return Dismissible(
                // Unique key is required for Dismissible
                key: Key(region.id.toString()),
                direction: DismissDirection.endToStart, // Swipe from right to left

                // Background (Red color with Delete Icon)
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white, size: 28),
                ),

                // --- CONFIRMATION DIALOG (Cupertino Style) ---
                confirmDismiss: (direction) async {
                  return await Get.dialog<bool>(
                    CupertinoAlertDialog(
                      title: const Text("Delete Region"),
                      content: Text("Are you sure you want to delete '${region.name}'?"),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text("Cancel"),
                          onPressed: () => Get.back(result: false), // Return false
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () => Get.back(result: true), // Return true
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                },

                // --- ACTION ON DELETE ---
                onDismissed: (direction) {
                  if (region.id != null) {
                    // Call controller to hit API
                    controller.deleteRegion(region.id!);
                  }
                },

                // The actual list item
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.zero, // Important: margin handled by ListView padding/separator
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Icon(Icons.map_outlined, color: Colors.blue),
                    ),
                    title: Text(
                      region.name ?? "Unnamed Region",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${region.city}, ${region.state}"),
                    trailing: Icon(
                      (region.isActive ?? false)
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: (region.isActive ?? false)
                          ? Colors.green
                          : Colors.red,
                    ),
                    onTap: () {
                      controller.gotoEditRegion(region);
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAddRegion,
        icon: const Icon(Icons.add),
        label: const Text("Add Region"),
      ),
    );
  }
}


/*
import 'package:admin/app/modules/regions_view/controllers/regions_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class RegionsScreen extends GetView<RegionsScreenController> {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Regions"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.regions.isEmpty) {
          return const Center(
            child: Text("No regions found. Add one to get started!"),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.regions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final region = controller.regions[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(Icons.map_outlined, color: Colors.blue),
                  ),
                  title: Text(
                    region.name ?? "Unnamed Region",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${region.city}, ${region.state}"),
                  trailing: Icon(
                    (region.isActive ?? false)
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: (region.isActive ?? false)
                        ? Colors.green
                        : Colors.red,
                  ),
                  onTap: () {
                    controller.gotoEditRegion(region);
                  },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAddRegion,
        icon: const Icon(Icons.add),
        label: const Text("Add Region"),
      ),
    );
  }
}
*/
