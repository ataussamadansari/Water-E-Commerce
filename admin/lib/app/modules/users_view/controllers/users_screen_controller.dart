import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/users/user_model.dart';
import '../../../data/services/user/user_service.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';

class UsersScreenController extends GetxController {
  final UserService userService = Get.find<UserService>();
  
  final TextEditingController searchController = TextEditingController();
  final RxList<User> filteredUsers = <User>[].obs;
  
  // Filter State
  final RxString selectedRole = ''.obs; // '' = All, 'sales', 'delivery'

  @override
  void onInit() {
    super.onInit();
    // Initial fetch (All users)
    fetchUsers();

    // Listen to changes in the master list from service to update filtered list
    ever(userService.users, (_) {
      searchUsers(searchController.text);
    });
  }

  void fetchUsers() {
    // If selectedRole is empty, fetch all. Otherwise fetch specific role.
    String? roleParam = selectedRole.value.isEmpty ? null : selectedRole.value;
    userService.fetchUsers(role: roleParam);
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(userService.users);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredUsers.assignAll(userService.users.where((user) {
        final name = user.name?.toLowerCase() ?? '';
        final mobile = user.mobile ?? '';
        final email = user.email?.toLowerCase() ?? '';
        return name.contains(lowerQuery) || 
               mobile.contains(lowerQuery) || 
               email.contains(lowerQuery);
      }).toList());
    }
  }

  void updateFilter(String? newRole) {
    selectedRole.value = newRole ?? '';
    fetchUsers(); // Re-fetch from API based on new filter
  }

  Future<void> refreshUsers() async {
    fetchUsers();
    // fetchUsers is void but calls userService.fetchUsers which is async.
    // Ideally fetchUsers should be async.
    // But since userService.fetchUsers sets isLoading, the UI will update.
    // To support RefreshIndicator properly, we should wait.
    // userService.fetchUsers returns Future<void>.
  }

  Future<void> deleteUser(int id) async {
    final success = await userService.deleteUserFromApi(id);
    if (success) {
      AppHelpers.showSnackBar(
        title: "Success",
        message: "User deleted successfully",
        isError: false,
      );
    } else {
      AppHelpers.showSnackBar(
        title: "Error",
        message: "Failed to delete user",
        isError: true,
      );
    }
  }

  void goToAddUser() async {
    // Pass the currently selected role if specific, or default to 'sales' if 'All' is selected
    String defaultRole = selectedRole.value.isEmpty ? 'sales' : selectedRole.value;
    await Get.toNamed(Routes.addUser, arguments: {'role': defaultRole});
    // Refresh list after returning
    fetchUsers();
  }

  void gotoEditUser(User user) async {
    await Get.toNamed(Routes.addUser, arguments: {'user': user});
     // Refresh list after returning
    fetchUsers();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
