import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/users/user_model.dart';
import '../../../data/repositories/users/user_repository.dart';
import '../../../data/services/user/user_service.dart';

class AddUserScreenController extends GetxController {
  final UserRepository _userRepo = UserRepository();
  final UserService _userService = Get.find<UserService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameController, mobileController, emailController;

  final RxString role = 'sales'.obs; // Default role
  final RxBool isActive = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;

  User? _userToEdit;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();

    // Check arguments
    if (Get.arguments != null) {
      if (Get.arguments['user'] != null) {
        isEditMode.value = true;
        _userToEdit = Get.arguments['user'];
        _populateFieldsForEdit();
      } else if (Get.arguments['role'] != null) {
        // Pre-select role if passed from list
        role.value = Get.arguments['role'];
      }
    }
  }

  void _populateFieldsForEdit() {
    final u = _userToEdit!;
    nameController.text = u.name ?? '';
    mobileController.text = u.mobile ?? '';
    emailController.text = u.email ?? '';
    role.value = u.role ?? 'sales';
    isActive.value = u.isActive ?? true;
  }

  Future<void> saveUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final userData = {
      'name': nameController.text.trim(),
      'mobile': mobileController.text.trim(),
      'email': emailController.text.trim(),
      'role': role.value,
      'is_active': isActive.value,
    };

    if (isEditMode.value) {
      // Update
      final response = await _userRepo.updateUser(_userToEdit!.id!, userData);
      if (response.success) {
        // Update local service
        _userService.updateUser(response.data!);
        Get.back(result: true);
        AppHelpers.showSnackBar(
          title: "Success",
          message: "User updated successfully!",
          isError: false,
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    } else {
      // Create
      final response = await _userRepo.createUser(userData);
      if (response.success) {
        // Add to local service (if role matches current view, but UserService handles simple list)
        // If we want the list to update immediately when we return, we can add it.
        // But since we refresh list on return in Controller, maybe not strictly needed.
        // But good practice to keep local state in sync.
        _userService.addUser(response.data!);
        Get.back(result: true);
        AppHelpers.showSnackBar(
          title: "Success",
          message: "User created successfully!",
          isError: false,
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    }

    isLoading.value = false;
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "This field is required";
    return null;
  }

  String? mobileValidator(String? value) {
    if (value == null || value.trim().isEmpty) return "Mobile is required";
    if (value.length < 10) return "Invalid mobile number";
    return null;
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
