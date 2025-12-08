import 'dart:io';

import 'package:customer/app/data/services/storage/storage_services.dart';
import 'package:dio/dio.dart' as dio; // Alias dio
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/profile/profile_service.dart';
import '../../../routes/app_routes.dart';

class ProfileScreenController extends GetxController {
  final ProfileService _profileService = Get.find<ProfileService>();
  final ImagePicker _picker = ImagePicker();

  // TextEditingControllers for editable fields
  final shopNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  // Observable for edit mode
  final RxBool isEditing = false.obs;
  
  // Selected Image
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Getters for service state
  bool get isLoading => _profileService.isLoading.value;
  get profileData => _profileService.profileData.value;

  @override
  void onInit() {
    super.onInit();
    // Listen to profile data changes to update text fields
    ever(_profileService.profileData, (_) => _populateFields());
    _populateFields();
  }

  void _populateFields() {
    final data = _profileService.profileData.value;
    if (data != null) {
      shopNameController.text = data.shopName ?? '';
      mobileController.text = data.mobile ?? '';
      addressController.text = data.addressLine ?? '';
      cityController.text = data.city ?? '';
      stateController.text = data.state ?? '';
      pincodeController.text = data.pincode ?? '';
    }
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // If cancelling edit, reset fields and image
      _populateFields();
      selectedImage.value = null;
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    // Use FormData for file upload
    final formData = dio.FormData.fromMap({
      "shop_name": shopNameController.text,
      "address_line": addressController.text,
      "city": cityController.text,
      "state": stateController.text,
      "pincode": pincodeController.text,
      "_method": "PUT", // Sometimes Laravel requires this for PUT requests with FormData
    });

    if (selectedImage.value != null) {
      formData.files.add(MapEntry(
        "shop_photo", // Ensure this key matches your backend expectation
        await dio.MultipartFile.fromFile(selectedImage.value!.path),
      ));
    }

    final success = await _profileService.updateProfile(formData);

    if (success) {
      isEditing.value = false;
      selectedImage.value = null; // Clear selected image on success
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
       Get.snackbar(
        "Error",
        _profileService.hasError.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> refreshProfile() async {
    await _profileService.fetchProfile();
  }

  void logout() {
    // Implement logout logic here
    StorageServices.to.removeToken();
    Get.offAllNamed(Routes.auth); 
  }
}
