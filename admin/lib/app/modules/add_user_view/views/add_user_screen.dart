import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/add_user_screen_controller.dart';
import '../../../global_widgets/form_widgets.dart';

class AddUserScreen extends GetView<AddUserScreenController> {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditMode.value ? 'Edit User' : 'Add New User',
        )),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("User Role"),
              // Role Selection (Radio or Toggle)
              Obx(() => Row(
                children: [
                  _buildRoleRadio("Sales", "sales"),
                  const SizedBox(width: 20),
                  _buildRoleRadio("Delivery", "delivery"),
                ],
              )),
              const SizedBox(height: 24),

              _buildSectionTitle("Personal Information"),
              FormWidgets.buildTextField(
                controller: controller.nameController,
                label: "Full Name",
                icon: Icons.person_outline,
                validator: controller.requiredValidator,
              ),
              const SizedBox(height: 16),

              FormWidgets.buildTextField(
                controller: controller.mobileController,
                label: "Mobile Number",
                icon: Icons.phone_android,
                validator: controller.mobileValidator,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              ),
              const SizedBox(height: 16),

              FormWidgets.buildTextField(
                controller: controller.emailController,
                label: "Email (Optional)",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle("Status"),
              FormWidgets.buildSwitchField(
                label: "Is Active Account",
                icon: Icons.check_circle_outline,
                value: controller.isActive,
              ),
              const SizedBox(height: 32),

              Obx(() => FormWidgets.buildSubmitButton(
                text: controller.isEditMode.value ? "Update User" : "Create User",
                isLoading: controller.isLoading,
                onPressed: controller.saveUser,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleRadio(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: controller.role.value,
          onChanged: (val) {
            if (val != null) controller.role.value = val;
          },
          activeColor: Theme.of(Get.context!).primaryColor,
        ),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
