import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for InputFormatters
import 'package:get/get.dart';
import '../controllers/auth_screen_controller.dart';

class AuthScreen extends GetView<AuthScreenController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Obx(() => Text(
                controller.isOtpSent.value ? "Verify OTP" : "Welcome Back",
                style: Theme.of(context).textTheme.headlineMedium,
              )),
              const SizedBox(height: 30),

              // Phone Input
              Obx(() => TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.number, // Changed to number for strict digits
                readOnly: controller.isOtpSent.value,
                maxLength: 10, // Enforce 10 digits
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only allow numbers
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  counterText: "", // Hides the "0/10" counter below the field
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                  suffixIcon: controller.isOtpSent.value
                      ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: controller.changeNumber,
                  )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              )),
              const SizedBox(height: 20),

              // OTP Input
              Obx(() {
                if (controller.isOtpSent.value) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: controller.otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 5, // Enforce 5 digits
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                        ],
                        decoration: const InputDecoration(
                          labelText: "Enter OTP",
                          counterText: "", // Hides the "0/5" counter
                          prefixIcon: Icon(Icons.lock_clock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // Action Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    if (controller.isOtpSent.value) {
                      controller.onVerifyOtp();
                    } else {
                      controller.onSendOtp();
                    }
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(controller.isOtpSent.value ? "Verify" : "Send OTP"),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
