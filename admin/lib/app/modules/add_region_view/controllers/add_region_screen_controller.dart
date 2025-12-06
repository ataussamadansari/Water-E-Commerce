import 'package:admin/app/core/utils/helpers.dart';
import 'package:admin/app/data/repositories/regions/region_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/regions/region_model.dart';

class AddRegionScreenController extends GetxController {
  final RegionRepository _regionRepo = RegionRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text field controllers
  late TextEditingController nameController;
  late TextEditingController cityController;
  late TextEditingController stateController;

  // Observable for the switch and loading state
  final RxBool isActive = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;
  Region? regionToEdit; // To hold the region object when editing

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();

    // Check if a region was passed for editing
    if (Get.arguments is Region) {
      isEditMode.value = true;
      regionToEdit = Get.arguments as Region;
      _populateFieldsForEdit();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.onClose();
  }

  // New method to pre-fill the form fields
  void _populateFieldsForEdit() {
    if (regionToEdit != null) {
      nameController.text = regionToEdit!.name ?? '';
      cityController.text = regionToEdit!.city ?? '';
      stateController.text = regionToEdit!.state ?? '';
      isActive.value = regionToEdit!.isActive ?? true;
    }
  }

  // --- COMBINED SAVE METHOD ---
  Future<void> saveRegion() async {
    if (isEditMode.value) {
      await _updateRegion();
    } else {
      await _addRegion();
    }
  }

  // Form submission logic
  Future<void> _addRegion() async {
    try {
      if (!formKey.currentState!.validate()) {
        AppHelpers.showSnackBar(
          title: "Validation Error",
          message: "Please fill all required fields.",
          isError: true,
        );
        return;
      }

      isLoading.value = true;

      final Map<String, dynamic> regionData = {
        'name': nameController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'is_active': isActive.value,
      };

      final response = await _regionRepo.createRegion(regionData);

      if (response.success && response.data != null) {
        Get.back(result: true);
        AppHelpers.showSnackBar(
          title: "Success",
          message: "Region '${response.data!.data?.name}' created successfully!",
          isError: false
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Creation Failed",
          message: response.message,
          isError: true,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(
        title: "Failed",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateRegion() async {
    try {
      if (!formKey.currentState!.validate()) return;
      if (regionToEdit == null) return;

      isLoading.value = true;

      final Map<String, dynamic> regionData = {
        'name': nameController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'is_active': isActive.value,
      };

      final response = await _regionRepo.updateRegion(
        regionToEdit!.id!,
        regionData,
      );

      if (response.success && response.data!.data != null) {
        Get.back(result: true);
        AppHelpers.showSnackBar(
            title: "Success",
            message: "Region '${response.data!.data?.name}' updated successfully!",
            isError: false
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Update Failed",
          message: response.message ,
          isError: true,
        );
      }
    } catch (e) {
      AppHelpers.showSnackBar(
        title: "Failed",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reusable validator
  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }
}
