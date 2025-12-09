import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_screen_controller.dart';

class AuthScreen extends GetView<AuthScreenController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define brand colors locally or get from your theme
    final primaryColor = Colors.blue.shade700;
    final lightBlue = Colors.blue.shade50;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background Decoration (Water Blobs)
              Positioned(
                top: -50,
                left: -50,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: lightBlue,
                ),
              ),
              Positioned(
                top: 100,
                right: -30,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: lightBlue.withOpacity(0.5),
                ),
              ),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo or Illustration Placeholder
                      Center(
                          child: Image.asset("assets/images/paavas_logo.png")
                      ),


                      // Dynamic Title
                      Obx(() => Text(
                        controller.isOtpSent.value
                            ? "Verify Your Number"
                            : "Get Started",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(height: 8),
                      Obx(() => Text(
                        controller.isOtpSent.value
                            ? "Enter the OTP sent to your mobile"
                            : "Enter your mobile number to login or register",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600
                        ),
                        textAlign: TextAlign.center,
                      )),
                      const SizedBox(height: 30),

                      // Phone Input
                      Obx(() => Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              )
                            ]
                        ),
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.number,
                          readOnly: controller.isOtpSent.value,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            counterText: "",
                            prefixIcon: Icon(Icons.phone_android, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            suffixIcon: controller.isOtpSent.value
                                ? IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: controller.changeNumber,
                              tooltip: "Change Number",
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
                        ),
                      )),
                      const SizedBox(height: 20),

                      // OTP Input
                      Obx(() {
                        if (controller.isOtpSent.value) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      )
                                    ]
                                ),
                                child: TextFormField(
                                  controller: controller.otpController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  textAlign: TextAlign.center, // Center the OTP
                                  style: const TextStyle(letterSpacing: 10, fontWeight: FontWeight.bold, fontSize: 18),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: "Enter OTP",
                                    counterText: "",
                                    prefixIcon: Icon(Icons.password, color: primaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    // fillColor: Colors.transparent,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      const SizedBox(height: 10),

                      // Action Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                              : Text(
                            controller.isOtpSent.value ? "Verify & Login" : "Send OTP",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
