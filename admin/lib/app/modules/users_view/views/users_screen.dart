import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/users_screen_controller.dart';

class UsersScreen extends GetView<UsersScreenController> {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.searchUsers,
              decoration: InputDecoration(
                hintText: "Search by name, mobile, or email...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          
          // 2. Filter Chips (Horizontal List)
          SizedBox(
            height: 50,
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip("All Users", ""),
                  const SizedBox(width: 8),
                  _buildFilterChip("Sales Team", "sales"),
                  const SizedBox(width: 8),
                  _buildFilterChip("Delivery Team", "delivery"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // 3. User List
          Expanded(
            child: Obx(() {
              if (controller.userService.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = controller.filteredUsers;

              if (users.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshUsers,
                  child: ListView(
                    children: const [
                       SizedBox(height: 50),
                       Center(child: Text("No users found.")),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshUsers,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Dismissible(
                      key: Key(user.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await Get.dialog<bool>(
                          CupertinoAlertDialog(
                            title: const Text("Delete User"),
                            content: Text("Are you sure you want to delete '${user.name}'?"),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text("Cancel"),
                                onPressed: () => Get.back(result: false),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () => Get.back(result: true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) => controller.deleteUser(user.id!),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () => controller.gotoEditUser(user),
                          leading: CircleAvatar(
                            backgroundColor: (user.role == 'sales' ? Colors.orange : Colors.blue).withOpacity(0.1),
                            child: Text(
                              user.name?.substring(0, 1).toUpperCase() ?? "U",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: user.role == 'sales' ? Colors.orange : Colors.blue
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text(user.name ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (user.role == 'sales' ? Colors.orange : Colors.blue).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  user.role?.toUpperCase() ?? "USER",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: (user.role == 'sales' ? Colors.orange : Colors.blue),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user.mobile != null) 
                                Row(children: [
                                  const Icon(Icons.phone, size: 14, color: Colors.grey), 
                                  const SizedBox(width: 4), 
                                  Text(user.mobile!)
                                ]),
                              if (user.email != null) 
                                Row(children: [
                                  const Icon(Icons.email, size: 14, color: Colors.grey), 
                                  const SizedBox(width: 4), 
                                  Text(user.email!)
                                ]),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (user.isActive ?? false) ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  (user.isActive ?? false) ? "Active" : "Inactive",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: (user.isActive ?? false) ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddUser,
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = controller.selectedRole.value == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.updateFilter(value);
      },
      selectedColor: Get.theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
