import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/customer_details_screen_controller.dart';

// Define FormWidgets locally if not imported from a separate file,
// otherwise remove this class and import it.
class FormWidgets {
  // A reusable text input field
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon, // Made nullable for optional icons
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false, // Added to support View Mode
  }) {
    // Logic to handle different styling for ReadOnly (View Mode) vs Edit Mode
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        // If readOnly, remove borders or make them invisible to look like plain text
        border: readOnly ? InputBorder.none : OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: readOnly ? InputBorder.none : OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: readOnly ? InputBorder.none : OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Get.theme.primaryColor),
        ),
        filled: !readOnly,
        contentPadding: readOnly ? const EdgeInsets.all(0) : null,
      ),
      validator: validator,
    );
  }

  // A reusable switch for boolean values
  static Widget buildSwitchField({
    required String label,
    required RxBool value,
    required IconData icon,
    bool isEditable = true, // Added to support View Mode
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Obx(
                () => Switch(
              value: value.value,
              onChanged: isEditable ? (newValue) => value.value = newValue : null,
            ),
          ),
        ],
      ),
    );
  }

  // A reusable submit button
  static Widget buildSubmitButton({
    required String text,
    required VoidCallback onPressed,
    required RxBool isLoading,
  }) {
    return Obx(
          () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading.value ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading.value
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(color: Colors.white),
          )
              : Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomerDetailsScreen extends GetView<CustomerDetailsScreenController> {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
        actions: [
          Obx(() => IconButton(
            icon: Icon(controller.isEditing.value ? Icons.close : Icons.edit),
            onPressed: controller.toggleEdit,
            tooltip: controller.isEditing.value ? "Cancel" : "Edit",
          ))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.customer.value == null) {
          return const Center(child: Text("No Data"));
        }

        final isEditing = controller.isEditing.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const Icon(Icons.store, size: 60, color: Colors.blueGrey),
                const SizedBox(height: 20),

                FormWidgets.buildTextField(
                  controller: controller.shopNameCtrl,
                  label: "Shop Name",
                  icon: Icons.storefront,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 16),

                // --- UPDATED: Mobile Field is now always ReadOnly ---
                FormWidgets.buildTextField(
                  controller: controller.mobileCtrl,
                  label: "Mobile",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  readOnly: true, // <--- Changed from !isEditing to true
                  // validation removed as it's read-only
                ),

                const Divider(height: 30),

                FormWidgets.buildTextField(
                  controller: controller.addressCtrl,
                  label: "Address",
                  icon: Icons.location_on,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: FormWidgets.buildTextField(
                        controller: controller.cityCtrl,
                        label: "City",
                        icon: Icons.location_city,
                        readOnly: !isEditing,
                        validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FormWidgets.buildTextField(
                        controller: controller.pincodeCtrl,
                        label: "Pincode",
                        icon: Icons.pin_drop,
                        keyboardType: TextInputType.number,
                        readOnly: !isEditing,
                        validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                FormWidgets.buildTextField(
                  controller: controller.stateCtrl,
                  label: "State",
                  icon: Icons.location_on,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),

                const Divider(height: 30),

                FormWidgets.buildTextField(
                  controller: controller.creditLimitCtrl,
                  label: "Credit Limit",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 16),

                // Switch for Approval
                FormWidgets.buildSwitchField(
                  label: "Is Approved?",
                  value: controller.isApproved,
                  icon: Icons.verified_user,
                  isEditable: isEditing,
                ),

                const SizedBox(height: 30),

                if (isEditing)
                  FormWidgets.buildSubmitButton(
                    text: "Save Changes",
                    onPressed: controller.updateCustomer,
                    isLoading: controller.isLoading,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
