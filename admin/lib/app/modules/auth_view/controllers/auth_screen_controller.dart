import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/services/storage/storage_services.dart';
import '../../../routes/app_routes.dart';

class AuthScreenController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final StorageServices _storageService = StorageServices.to;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController phoneController;
  late TextEditingController otpController;

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isOtpSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  // 1. Send OTP Action
  Future<void> onSendOtp() async {
    // This triggers the validator in AuthScreen (checking for exactly 10 digits)
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final response = await _authRepo.sendOtp(phoneController.text.trim());

    isLoading.value = false;

    if (response.success) {
      isOtpSent.value = true;
      Get.snackbar("Success", response.data!.message!, backgroundColor: Colors.green.withOpacity(0.2));
    } else {
      Get.snackbar("Error", response.message, backgroundColor: Colors.red.withOpacity(0.2));
    }
  }

  // 2. Verify OTP Action
  Future<void> onVerifyOtp() async {
    // Updated check: Must be exactly 5 digits
    if (otpController.text.trim().length != 5) {
      Get.snackbar("Error", "Please enter a valid 5-digit OTP");
      return;
    }

    isLoading.value = true;

    final response = await _authRepo.verifyOtp(
      phoneController.text.trim(),
      otpController.text.trim(),
      "admin",
    );

    isLoading.value = false;

    if (response.success && response.data?.data!.accessToken != null) {
      // Save Token
      _storageService.setToken(response.data?.data!.accessToken ?? "n/a");

      Get.offAllNamed(Routes.dashboard);
    } else {
      Get.snackbar("Error", response.message, backgroundColor: Colors.red.withOpacity(0.2));
    }
  }

  // Reset view to change number
  void changeNumber() {
    isOtpSent.value = false;
    otpController.clear();
  }
}
