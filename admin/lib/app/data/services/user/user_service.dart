import 'package:get/get.dart';
import '../../models/users/user_model.dart';
import '../../repositories/users/user_repository.dart';

class UserService extends GetxService {
  final UserRepository _repository = UserRepository();

  // Reactive list of users (Main list for UsersScreen)
  final RxList<User> users = <User>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchUsers(); // Let controller trigger it
  }

  // Fetch all users (optionally filter by role)
  Future<void> fetchUsers({String? role}) async {
    try {
      isLoading.value = true;
      final response = await _repository.getUsers(role: role);
      if (response.success && response.data?.data != null) {
        users.assignAll(response.data!.data!);
      } else {
        users.clear();
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch delivery users specifically (returns a new list, doesn't affect main list)
  Future<List<User>> getDeliveryUsers() async {
    try {
      final response = await _repository.getUsers(role: 'delivery');
      if (response.success && response.data?.data != null) {
        return response.data!.data!;
      }
      return [];
    } catch (e) {
      print("Error fetching delivery users: $e");
      return [];
    }
  }

  // Add a user locally
  void addUser(User user) {
    users.add(user);
    users.refresh();
  }

  // Update a user locally
  void updateUser(User user) {
    final index = users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      users[index] = user;
      users.refresh();
    }
  }

  // Delete user from API and update local list
  Future<bool> deleteUserFromApi(int id) async {
    try {
      final response = await _repository.deleteUser(id);
      if (response.success) {
        users.removeWhere((u) => u.id == id);
        users.refresh();
        return true;
      }
      return false;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }
}
